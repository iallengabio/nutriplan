import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';
import '../../core/services/rate_limit_service.dart';
import '../../domain/models/shopping_list.dart';
import '../../domain/models/menu.dart';
import '../../domain/repositories/shopping_list_repository.dart';
import '../../domain/services/ai_api_service.dart';

/// Implementação do ShoppingListRepository usando Firebase Firestore
class FirestoreShoppingListRepository implements ShoppingListRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final AiApiService _aiApiService;

  FirestoreShoppingListRepository(
    this._firestore,
    this._auth,
    this._aiApiService,
  );

  /// Obtém o ID do usuário atual
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Referência para a coleção de listas de compras do usuário atual
  CollectionReference? get _shoppingListsCollection {
    final userId = _currentUserId;
    if (userId == null) return null;
    return _firestore.collection('users').doc(userId).collection('shopping_lists');
  }

  @override
  Future<Result<ShoppingList>> gerarListaCompras({
    required Menu menu,
    required int numeroSemanas,
    String? nome,
    String? observacoes,
  }) async {
    try {
      if (_currentUserId == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      // Verifica rate limiting
      final canMakeCall = await RateLimitService.canMakeCall(_currentUserId!);
      if (!canMakeCall) {
        final remainingCalls = await RateLimitService.getRemainingCalls(_currentUserId!);
        return Failure(Exception(
          'Limite diário de gerações atingido. Você pode gerar até ${RateLimitService.maxCallsPerDay} listas por dia.',
        ));
      }

      // Gera a lista de compras usando IA
      final listaResult = await _aiApiService.gerarListaCompras(
        menu: menu,
        numeroSemanas: numeroSemanas,
        nome: nome,
        observacoes: observacoes,
        numberOfPeople: menu.numberOfPeople,
      );

      return await listaResult.fold(
        (lista) async {
          // Registra a chamada bem-sucedida
          await RateLimitService.recordCall(_currentUserId!);
          return Success(lista);
        },
        (error) => Failure(Exception(error.toString())),
      );
    } catch (e) {
      return Failure(Exception('Erro ao gerar lista de compras: $e'));
    }
  }

  @override
  Future<Result<void>> salvarListaCompras(ShoppingList lista) async {
    try {
      final collection = _shoppingListsCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }
      await collection.doc(lista.id).set(lista.toJson());
      return const Success(());
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao salvar lista de compras: $e'));
    }
  }

  @override
  Future<Result<ShoppingList>> salvarNovaListaCompras(ShoppingList lista) async {
    try {
      final collection = _shoppingListsCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }
      
      // Gera um novo ID automaticamente pelo Firebase
      final docRef = collection.doc();
      final listaComNovoId = lista.copyWith(id: docRef.id);
      
      await docRef.set(listaComNovoId.toJson());
      
      return Success(listaComNovoId);
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao salvar nova lista de compras: $e'));
    }
  }

  @override
  Future<Result<List<ShoppingList>>> listarListasCompras() async {
    try {
      final collection = _shoppingListsCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final querySnapshot = await collection
          .orderBy('dataCriacao', descending: true)
          .get();

      final listas = querySnapshot.docs
          .map((doc) => ShoppingList.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return Success(listas);
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao listar listas de compras: $e'));
    }
  }

  @override
  Future<Result<ShoppingList>> buscarListaCompraPorId(String id) async {
    try {
      final collection = _shoppingListsCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final doc = await collection.doc(id).get();
      
      if (!doc.exists) {
        return Failure(Exception('Lista com ID $id não encontrada'));
      }

      final lista = ShoppingList.fromJson(doc.data() as Map<String, dynamic>);
      return Success(lista);
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao buscar lista de compras: $e'));
    }
  }

  @override
  Future<Result<void>> atualizarListaCompras(ShoppingList lista) async {
    try {
      final collection = _shoppingListsCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      await collection.doc(lista.id).update(lista.toJson());
      return const Success(());
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao atualizar lista de compras: $e'));
    }
  }

  @override
  Future<Result<void>> removerListaCompras(String id) async {
    try {
      final collection = _shoppingListsCollection;
      if (collection == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      await collection.doc(id).delete();
      return const Success(());
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro do Firestore: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro ao remover lista de compras: $e'));
    }
  }

  @override
  Future<Result<ShoppingList>> duplicarListaCompras(String listaId) async {
    try {
      final listaResult = await buscarListaCompraPorId(listaId);
      
      return await listaResult.fold(
        (lista) async {
          final listaDuplicada = lista.copyWith(
            id: '', // Será gerado automaticamente
            nome: '${lista.nome} (Cópia)',
            dataCriacao: DateTime.now(),
          );
          
          return await salvarNovaListaCompras(listaDuplicada);
        },
        (error) => Failure(error),
      );
    } catch (e) {
      return Failure(Exception('Erro ao duplicar lista de compras: $e'));
    }
  }

  @override
  Future<Result<void>> adicionarItem(String listaId, ShoppingItem item) async {
    try {
      final listaResult = await buscarListaCompraPorId(listaId);
      
      return await listaResult.fold(
        (lista) async {
          final novosItens = [...lista.itens, item];
          final listaAtualizada = lista.copyWith(itens: novosItens);
          return await atualizarListaCompras(listaAtualizada);
        },
        (error) => Failure(error),
      );
    } catch (e) {
      return Failure(Exception('Erro ao adicionar item: $e'));
    }
  }

  @override
  Future<Result<void>> removerItem(String listaId, String itemId) async {
    try {
      final listaResult = await buscarListaCompraPorId(listaId);
      
      return await listaResult.fold(
        (lista) async {
          final novosItens = lista.itens.where((item) => item.id != itemId).toList();
          final listaAtualizada = lista.copyWith(itens: novosItens);
          return await atualizarListaCompras(listaAtualizada);
        },
        (error) => Failure(error),
      );
    } catch (e) {
      return Failure(Exception('Erro ao remover item: $e'));
    }
  }

  @override
  Future<Result<void>> atualizarItem(String listaId, ShoppingItem item) async {
    try {
      final listaResult = await buscarListaCompraPorId(listaId);
      
      return await listaResult.fold(
        (lista) async {
          final novosItens = lista.itens.map((i) => i.id == item.id ? item : i).toList();
          final listaAtualizada = lista.copyWith(itens: novosItens);
          return await atualizarListaCompras(listaAtualizada);
        },
        (error) => Failure(error),
      );
    } catch (e) {
      return Failure(Exception('Erro ao atualizar item: $e'));
    }
  }

  @override
  Future<Result<void>> marcarItemComprado(String listaId, String itemId, bool comprado) async {
    try {
      final listaResult = await buscarListaCompraPorId(listaId);
      
      return await listaResult.fold(
        (lista) async {
          final novosItens = lista.itens.map((item) {
            if (item.id == itemId) {
              return item.copyWith(comprado: comprado);
            }
            return item;
          }).toList();
          
          final listaAtualizada = lista.copyWith(itens: novosItens);
          return await atualizarListaCompras(listaAtualizada);
        },
        (error) => Failure(error),
      );
    } catch (e) {
      return Failure(Exception('Erro ao marcar item como comprado: $e'));
    }
  }
}