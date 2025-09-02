import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';
import '../../domain/models/perfil_familiar.dart';
import '../../domain/repositories/family_profile_repository.dart';

/// Implementação do FamilyProfileRepository usando Firebase Firestore
class FirebaseFamilyProfileRepository implements FamilyProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseFamilyProfileRepository(
    this._firestore,
    this._auth,
  );

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference? get _profileCollection {
    if (_userId == null) return null;
    return _firestore.collection('users').doc(_userId).collection('profile');
  }

  @override
  Future<Result<PerfilFamiliar>> carregarPerfilFamiliar() async {
    try {
      if (_userId == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final doc = await _profileCollection!.doc('family').get();
      
      if (!doc.exists) {
        // Se não existe perfil, cria um padrão
        final perfilPadrao = PerfilFamiliar.padrao(_userId!);
        await salvarPerfilFamiliar(perfilPadrao);
        return Success(perfilPadrao);
      }

      final data = doc.data() as Map<String, dynamic>;
      final perfil = PerfilFamiliar.fromJson(data);
      return Success(perfil);
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro ao carregar perfil familiar: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro desconhecido ao carregar perfil familiar: $e'));
    }
  }

  @override
  Future<Result<void>> salvarPerfilFamiliar(PerfilFamiliar perfil) async {
    try {
      if (_userId == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final perfilAtualizado = perfil.atualizar();
      await _profileCollection!.doc('family').set(perfilAtualizado.toJson());
      return const Success(());
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro ao salvar perfil familiar: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro desconhecido ao salvar perfil familiar: $e'));
    }
  }

  @override
  Future<Result<PerfilFamiliar>> criarPerfilPadrao(String userId) async {
    try {
      final perfilPadrao = PerfilFamiliar.padrao(userId);
      final resultado = await salvarPerfilFamiliar(perfilPadrao);
      
      return resultado.fold(
        (success) => Success(perfilPadrao),
        (failure) => Failure(failure),
      );
    } catch (e) {
      return Failure(Exception('Erro ao criar perfil padrão: $e'));
    }
  }

  @override
  Future<Result<void>> atualizarPerfilFamiliar(PerfilFamiliar perfil) async {
    return salvarPerfilFamiliar(perfil);
  }

  @override
  Future<Result<bool>> possuiPerfilFamiliar() async {
    try {
      if (_userId == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final doc = await _profileCollection!.doc('family').get();
      return Success(doc.exists);
    } on FirebaseException catch (e) {
      return Failure(Exception('Erro ao verificar perfil familiar: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro desconhecido ao verificar perfil familiar: $e'));
    }
  }
}