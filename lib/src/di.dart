import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/models/user.dart' as domain_user;

// Provider do Firebase Auth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Provider do AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return AuthRepositoryImpl(firebaseAuth);
});

// Provider para monitorar o estado de autenticação
final authStateProvider = StreamProvider<domain_user.User?>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Provider para verificar se o usuário está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.isAuthenticated;
});

// Provider para obter o usuário atual
final currentUserProvider = FutureProvider<domain_user.User?>((ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  return await authRepository.getCurrentUser();
});