import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_viewmodel.dart';
import '../register/register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);

    // Escuta mudanças de estado para navegação
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next is LoginSuccess) {
        // Navegar para a tela principal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login realizado com sucesso!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        // TODO: Implementar navegação para home
      } else if (next is LoginError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } else if (next is ForgotPasswordSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Email de recuperação enviado!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        loginViewModel.resetState();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                
                // Logo e título
                _buildHeader(),
                
                const SizedBox(height: 48),
                
                // Campos de entrada
                _buildEmailField(loginViewModel),
                const SizedBox(height: 16),
                _buildPasswordField(loginViewModel),
                
                const SizedBox(height: 12),
                
                // Lembrar-me e Esqueci a senha
                _buildRememberAndForgot(loginViewModel),
                
                const SizedBox(height: 32),
                
                // Botão de login
                _buildLoginButton(loginState, loginViewModel),
                
                const SizedBox(height: 24),
                
                // Divisor
                _buildDivider(),
                
                const SizedBox(height: 24),
                
                // Link para registro
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            // color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.restaurant_menu,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'NutriPlan',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bem-vindo de volta!',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(LoginViewModel viewModel) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: viewModel.validateEmail,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Digite seu email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _buildPasswordField(LoginViewModel viewModel) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      validator: viewModel.validatePassword,
      onFieldSubmitted: (_) => _handleLogin(viewModel),
      decoration: InputDecoration(
        labelText: 'Senha',
        hintText: 'Digite sua senha',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _buildRememberAndForgot(LoginViewModel viewModel) {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
        ),
        const Text('Lembrar-me'),
        const Spacer(),
        TextButton(
          onPressed: () => _showForgotPasswordDialog(viewModel),
          child: Text(
            'Esqueci a senha',
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginState state, LoginViewModel viewModel) {
    final isLoading = state is LoginLoading;
    
    return ElevatedButton(
      onPressed: isLoading ? null : () => _handleLogin(viewModel),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Entrar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ou',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          child: Text(
            'Cadastre-se',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin(LoginViewModel viewModel) {
    if (_formKey.currentState?.validate() ?? false) {
      final command = LoginCommand(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      viewModel.executeLogin(command);
    }
  }

  void _showForgotPasswordDialog(LoginViewModel viewModel) {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar Senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Digite seu email para receber as instruções de recuperação de senha.',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                final command = ForgotPasswordCommand(emailController.text.trim());
                viewModel.executeForgotPassword(command);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}