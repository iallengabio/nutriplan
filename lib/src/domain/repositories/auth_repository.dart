import 'package:result_dart/result_dart.dart';
import '../models/user.dart';

abstract class AuthRepository {
  /// Realiza login com email e senha
  Future<Result<User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registra novo usuário com email e senha
  Future<Result<User>> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  /// Realiza logout do usuário atual
  Future<Result<void>> signOut();

  /// Recupera senha via email
  Future<Result<void>> resetPassword({
    required String email,
  });

  /// Obtém o usuário atualmente logado
  Future<User?> getCurrentUser();

  /// Stream que monitora mudanças no estado de autenticação
  Stream<User?> get authStateChanges;

  /// Verifica se há um usuário logado
  bool get isAuthenticated;
}