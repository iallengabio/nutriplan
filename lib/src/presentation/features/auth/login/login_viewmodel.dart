import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/user.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../di.dart';

// Estados do Login
sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final User user;
  const LoginSuccess(this.user);
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}

class ForgotPasswordSuccess extends LoginState {
  const ForgotPasswordSuccess();
}

// Commands para Login
class LoginCommand {
  final String email;
  final String password;
  
  const LoginCommand({
    required this.email,
    required this.password,
  });
}

class ForgotPasswordCommand {
  final String email;
  
  const ForgotPasswordCommand(this.email);
}

// ViewModel do Login
class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  
  LoginViewModel(this._authRepository) : super(const LoginInitial());
  
  /// Executa o comando de login
  Future<void> executeLogin(LoginCommand command) async {
    if (state is LoginLoading) return; // Evita múltiplas execuções
    
    state = const LoginLoading();
    
    final result = await _authRepository.signInWithEmailAndPassword(
      email: command.email,
      password: command.password,
    );
    
    result.fold(
      (user) => state = LoginSuccess(user),
      (exception) => state = LoginError(exception.toString()),
    );
  }
  
  /// Executa o comando de recuperação de senha
  Future<void> executeForgotPassword(ForgotPasswordCommand command) async {
    if (state is LoginLoading) return;
    
    state = const LoginLoading();
    
    final result = await _authRepository.resetPassword(
      email: command.email,
    );
    
    result.fold(
      (_) => state = const ForgotPasswordSuccess(),
      (exception) => state = LoginError(exception.toString()),
    );
  }
  
  /// Reseta o estado para inicial
  void resetState() {
    state = const LoginInitial();
  }
  
  /// Verifica se o formulário pode ser submetido
  bool canSubmit(String email, String password) {
    return email.isNotEmpty && 
           password.isNotEmpty && 
           state is! LoginLoading;
  }
  
  /// Valida email
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Email inválido';
    }
    
    return null;
  }
  
  /// Valida senha
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (password.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    
    return null;
  }
}

// Provider do ViewModel
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginViewModel(authRepository);
});