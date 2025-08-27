import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/user.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../di.dart';

// Estados do Register
sealed class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final User user;
  const RegisterSuccess(this.user);
}

class RegisterError extends RegisterState {
  final String message;
  const RegisterError(this.message);
}

// Commands para Register
class RegisterCommand {
  final String email;
  final String password;
  final String confirmPassword;
  final String? displayName;
  
  const RegisterCommand({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.displayName,
  });
}

// ViewModel do Register
class RegisterViewModel extends StateNotifier<RegisterState> {
  final AuthRepository _authRepository;
  
  RegisterViewModel(this._authRepository) : super(const RegisterInitial());
  
  /// Executa o comando de registro
  Future<void> executeRegister(RegisterCommand command) async {
    if (state is RegisterLoading) return; // Evita múltiplas execuções
    
    // Validação de senhas
    if (command.password != command.confirmPassword) {
      state = const RegisterError('As senhas não coincidem');
      return;
    }
    
    state = const RegisterLoading();
    
    final result = await _authRepository.registerWithEmailAndPassword(
      email: command.email,
      password: command.password,
      displayName: command.displayName,
    );
    
    result.fold(
      (user) => state = RegisterSuccess(user),
      (exception) => state = RegisterError(exception.toString()),
    );
  }
  
  /// Reseta o estado para inicial
  void resetState() {
    state = const RegisterInitial();
  }
  
  /// Verifica se o formulário pode ser submetido
  bool canSubmit(String email, String password, String confirmPassword) {
    return email.isNotEmpty && 
           password.isNotEmpty && 
           confirmPassword.isNotEmpty &&
           state is! RegisterLoading;
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
    
    // Validações adicionais de força da senha
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Senha deve conter pelo menos uma letra maiúscula';
    }
    
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Senha deve conter pelo menos um número';
    }
    
    return null;
  }
  
  /// Valida confirmação de senha
  String? validateConfirmPassword(String? confirmPassword, String password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    
    if (confirmPassword != password) {
      return 'As senhas não coincidem';
    }
    
    return null;
  }
  
  /// Valida nome de exibição (opcional)
  String? validateDisplayName(String? displayName) {
    if (displayName != null && displayName.isNotEmpty) {
      if (displayName.length < 2) {
        return 'Nome deve ter pelo menos 2 caracteres';
      }
      
      if (displayName.length > 50) {
        return 'Nome deve ter no máximo 50 caracteres';
      }
      
      // Verifica se contém apenas letras, espaços e alguns caracteres especiais
      if (!RegExp(r'^[a-zA-ZÀ-ÿ\s\-\.]+$').hasMatch(displayName)) {
        return 'Nome contém caracteres inválidos';
      }
    }
    
    return null;
  }
}

// Provider do ViewModel
final registerViewModelProvider = StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterViewModel(authRepository);
});