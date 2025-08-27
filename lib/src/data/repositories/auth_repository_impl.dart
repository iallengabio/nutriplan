import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:result_dart/result_dart.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<Result<User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return Failure(Exception('Falha na autenticação'));
      }

      final user = _mapFirebaseUserToUser(credential.user!);
      return Success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(Exception(_getErrorMessage(e.code)));
    } catch (e) {
      return Failure(Exception('Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<User>> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return Failure(Exception('Falha no registro'));
      }

      // Atualiza o displayName se fornecido
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.reload();
      }

      final user = _mapFirebaseUserToUser(credential.user!);
      return Success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(Exception(_getErrorMessage(e.code)));
    } catch (e) {
      return Failure(Exception('Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return Success(());
    } catch (e) {
      return Failure(Exception('Erro ao fazer logout: $e'));
    }
  }

  @override
  Future<Result<void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return Success(());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(Exception(_getErrorMessage(e.code)));
    } catch (e) {
      return Failure(Exception('Erro inesperado: $e'));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    
    return _mapFirebaseUserToUser(firebaseUser);
  }

  @override
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return _mapFirebaseUserToUser(firebaseUser);
    });
  }

  @override
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  /// Mapeia um FirebaseUser para nosso modelo User
  User _mapFirebaseUserToUser(firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      lastLoginAt: firebaseUser.metadata.lastSignInTime,
    );
  }

  /// Converte códigos de erro do Firebase em mensagens amigáveis
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'email-already-in-use':
        return 'Este email já está em uso';
      case 'weak-password':
        return 'A senha é muito fraca';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Usuário desabilitado';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde';
      case 'operation-not-allowed':
        return 'Operação não permitida';
      default:
        return 'Erro de autenticação: $errorCode';
    }
  }
}