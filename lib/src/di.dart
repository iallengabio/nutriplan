import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/models/user.dart' as domain_user;
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/settings_repository.dart';
import 'presentation/features/settings/settings_viewmodel.dart';
import 'presentation/features/settings/settings_state.dart';
import 'data/repositories/firestore_menu_repository.dart';
import 'data/repositories/firestore_shopping_list_repository.dart';
import 'data/services/ai_api_service_mock.dart';
import 'data/services/gemini_ai_service.dart';
import 'core/constants/api_keys.dart';
import 'domain/repositories/menu_repository.dart';
import 'domain/repositories/shopping_list_repository.dart';
import 'domain/services/ai_api_service.dart';
import 'domain/services/user_initialization_service.dart';
import 'presentation/features/home/cardapios/menu_viewmodel.dart';
import 'presentation/features/home/listas/shopping_list_viewmodel.dart';
import 'data/repositories/firebase_family_profile_repository.dart';
import 'domain/repositories/family_profile_repository.dart';
import 'presentation/features/profile/family_profile_viewmodel.dart';
import 'presentation/features/auth/register/register_viewmodel.dart';

// Provider do Firebase Auth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Provider do Firestore
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
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

// Provider do SettingsRepository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

// Provider do SettingsViewModel
final settingsViewModelProvider = StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
  final repository = ref.read(settingsRepositoryProvider);
  return SettingsViewModel(repository);
});

// Provider do AiApiService
// Usa Gemini se a chave estiver configurada, senão usa o mock
final aiApiServiceProvider = Provider<AiApiService>((ref) {
  if (ApiKeys.isGeminiConfigured) {
    return GeminiAiService();
  } else {
    return AiApiServiceMock();
  }
});

// Provider específico para o mock (para testes)
final aiApiServiceMockProvider = Provider<AiApiService>((ref) {
  return AiApiServiceMock();
});

// Provider específico para o Gemini
final geminiAiServiceProvider = Provider<AiApiService>((ref) {
  return GeminiAiService();
});

// Provider do MenuRepository (usando Firestore)
final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final aiApiService = ref.read(aiApiServiceProvider);
  return FirestoreMenuRepository(
    firestore,
    firebaseAuth,
    aiApiService,
  );
});

// Provider do MenuViewModel
final menuViewModelProvider = StateNotifierProvider<MenuViewModel, MenuState>((ref) {
  final repository = ref.read(menuRepositoryProvider);
  final shoppingListRepository = ref.read(shoppingListRepositoryProvider);
  return MenuViewModel(repository, shoppingListRepository);
});

// Provider do ShoppingListRepository (usando Firestore)
final shoppingListRepositoryProvider = Provider<ShoppingListRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final aiApiService = ref.read(aiApiServiceProvider);
  return FirestoreShoppingListRepository(
    firestore,
    firebaseAuth,
    aiApiService,
  );
});

// Provider do ShoppingListViewModel
final shoppingListViewModelProvider = StateNotifierProvider<ShoppingListViewModel, ShoppingListState>((ref) {
  final repository = ref.read(shoppingListRepositoryProvider);
  return ShoppingListViewModel(repository);
});

// Provider do FamilyProfileRepository (usando Firebase)
final familyProfileRepositoryProvider = Provider<FamilyProfileRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return FirebaseFamilyProfileRepository(
    firestore,
    firebaseAuth,
  );
});

// Provider do FamilyProfileViewModel
final familyProfileViewModelProvider = StateNotifierProvider<FamilyProfileViewModel, FamilyProfileState>((ref) {
  final repository = ref.read(familyProfileRepositoryProvider);
  return FamilyProfileViewModel(repository);
});

// Provider do UserInitializationService
final userInitializationServiceProvider = Provider<UserInitializationService>((ref) {
  final familyProfileRepository = ref.read(familyProfileRepositoryProvider);
  return UserInitializationServiceImpl(familyProfileRepository);
});

// Provider do RegisterViewModel
final registerViewModelProvider = StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  final userInitializationService = ref.read(userInitializationServiceProvider);
  return RegisterViewModel(authRepository, userInitializationService);
});