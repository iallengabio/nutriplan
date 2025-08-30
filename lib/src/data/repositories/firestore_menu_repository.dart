import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';
import '../../core/services/rate_limit_service.dart';
import '../../domain/models/menu.dart';
import '../../domain/models/perfil_familiar.dart';
import '../../domain/models/refeicao.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/services/ai_api_service.dart';

/// Implementação do MenuRepository usando Firebase Firestore
class FirestoreMenuRepository implements MenuRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final AiApiService _aiApiService;

  FirestoreMenuRepository(
    this._firestore,
    this._auth,
    this._aiApiService,
  );

  /// Obtém o ID do usuário atual
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Referência para a coleção de menus do usuário atual
  CollectionReference? get _menusCollection {
    final userId = _currentUserId;
    if (userId == null) return null;
    return _firestore.collection('users').doc(userId).collection('menus');
  }

  @override
  Future<Result<Menu>> gerarMenu({
    required PerfilFamiliar perfil,
    required Set<TipoRefeicao> tiposRefeicao,
    String? nome,
    String? observacoesAdicionais,
    int? numberOfPeople,
  }) async {
    try {
      if (_currentUserId == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      // Verifica rate limiting
      final canMakeCall = await RateLimitService.canMakeCall(_currentUserId!);
      if (!canMakeCall) {
        final remainingCalls = await RateLimitService.getRemainingCalls(_currentUserId!);
        return Failure(RateLimitExceededException(
          message: 'Limite diário de gerações atingido. Você pode gerar até ${RateLimitService.maxCallsPerDay} cardápios por dia.',
          remainingCalls: remainingCalls,
          maxCalls: RateLimitService.maxCallsPerDay,
        ));
      }

      // Gera o cardápio usando IA
      final menuResult = await _aiApiService.gerarCardapio(
        perfil: perfil,
        tiposRefeicao: tiposRefeicao,
        nome: nome,
        observacoesAdicionais: observacoesAdicionais,
        numberOfPeople: numberOfPeople,
      );

      return await menuResult.fold(
        (menu) async {
          // Registra a chamada bem-sucedida
          await RateLimitService.recordCall(_currentUserId!);
          return Success(menu);
        },
        (error) => Failure(Exception(error.toString())),
      );
    } catch (e) {
      return Failure(Exception('Erro ao gerar cardápio: $e'));
    }
  }

  @override
  Future<Result<void>> salvarMenu(Menu menu) async {
    try {
      final collection = _menusCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }
      await collection.doc(menu.id).set(menu.toJson());
      return const Success(());
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao salvar cardápio: $e'));
    }
  }

  /// Salva um novo cardápio permitindo que o Firebase gere o ID automaticamente
  @override
  Future<Result<Menu>> salvarNovoMenu(Menu menu) async {
    try {
      final collection = _menusCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }
      
      // Gera um novo ID automaticamente pelo Firebase
      final docRef = collection.doc();
      final menuComNovoId = menu.copyWith(id: docRef.id);
      
      await docRef.set(menuComNovoId.toJson());
      
      return Success(menuComNovoId);
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao salvar novo cardápio: $e'));
    }
  }

  @override
  Future<Result<List<Menu>>> listarMenus() async {
    try {
      final collection = _menusCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final querySnapshot = await collection
          .orderBy('dataCriacao', descending: true)
          .get();

      final menus = querySnapshot.docs
          .map((doc) => Menu.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return Success(menus);
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao listar cardápios: $e'));
    }
  }

  @override
  Future<Result<Menu>> buscarMenuPorId(String id) async {
    try {
      final collection = _menusCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final doc = await collection.doc(id).get();
      
      if (!doc.exists) {
        return Failure(Exception('Menu com ID $id não encontrado'));
      }

      final menu = Menu.fromJson(doc.data() as Map<String, dynamic>);
      return Success(menu);
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao buscar cardápio: $e'));
    }
  }

  @override
  Future<Result<void>> atualizarMenu(Menu menu) async {
    try {
      final collection = _menusCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      // Verifica se o menu existe
      final doc = await collection.doc(menu.id).get();
      if (!doc.exists) {
        return Failure(Exception('Menu com ID ${menu.id} não encontrado'));
      }

      // Atualiza com timestamp de última edição
      final menuAtualizado = menu.copyWith(dataUltimaEdicao: DateTime.now());
      await collection.doc(menu.id).update(menuAtualizado.toJson());
      
      return const Success(());
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao atualizar cardápio: $e'));
    }
  }

  @override
  Future<Result<void>> removerMenu(String id) async {
    try {
      final collection = _menusCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      // Verifica se o menu existe
      final doc = await collection.doc(id).get();
      if (!doc.exists) {
        return Failure(Exception('Menu com ID $id não encontrado'));
      }

      await collection.doc(id).delete();
      return const Success(());
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao remover cardápio: $e'));
    }
  }

  @override
  Future<Result<Refeicao>> gerarRefeicaoAlternativa({
    required PerfilFamiliar perfil,
    required TipoRefeicao tipo,
    String? observacoesAdicionais,
  }) async {
    try {
      if (_currentUserId == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      // Verifica rate limiting
      final canMakeCall = await RateLimitService.canMakeCall(_currentUserId!);
      if (!canMakeCall) {
        final remainingCalls = await RateLimitService.getRemainingCalls(_currentUserId!);
        return Failure(RateLimitExceededException(
          message: 'Limite diário de gerações atingido. Você pode gerar até ${RateLimitService.maxCallsPerDay} refeições alternativas por dia.',
          remainingCalls: remainingCalls,
          maxCalls: RateLimitService.maxCallsPerDay,
        ));
      }

      // Gera a refeição alternativa usando IA
      final refeicaoResult = await _aiApiService.gerarRefeicaoAlternativa(
        perfil: perfil,
        tipo: tipo,
        observacoesAdicionais: observacoesAdicionais,
      );

      return await refeicaoResult.fold(
        (refeicao) async {
          // Registra a chamada bem-sucedida
          await RateLimitService.recordCall(_currentUserId!);
          return Success(refeicao);
        },
        (error) => Failure(Exception(error.toString())),
      );
    } catch (e) {
      return Failure(Exception('Erro ao gerar refeição alternativa: $e'));
    }
  }

  @override
  Future<Result<Menu>> duplicarMenu(String menuId) async {
    try {
      final collection = _menusCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      // Busca o menu original
      final menuResult = await buscarMenuPorId(menuId);
      
      return menuResult.fold(
        (menuOriginal) async {
          // Cria uma cópia com novo ID e data
          final menuDuplicado = menuOriginal.copyWith(
            id: _firestore.collection('temp').doc().id, // Gera novo ID
            nome: '${menuOriginal.nome} (Cópia)',
            dataCriacao: DateTime.now(),
            dataUltimaEdicao: null,
          );

          // Salva o menu duplicado
          final salvarResult = await salvarMenu(menuDuplicado);
          
          return salvarResult.fold(
            (_) => Success(menuDuplicado),
            (error) => Failure(error),
          );
        },
        (error) => Failure(error),
      );
    } catch (e) {
      return Failure(Exception('Erro ao duplicar cardápio: $e'));
    }
  }
}