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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                const HeaderWidget(),

                const SizedBox(height: 48),

                // Campos de entrada
                EmailField(
                  controller: _emailController,
                  viewModel: loginViewModel,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _passwordController,
                  viewModel: loginViewModel,
                ),

                const SizedBox(height: 12),

                // Lembrar-me e Esqueci a senha
                RememberAndForgotWidget(emailController: _emailController),

                const SizedBox(height: 32),

                // Botão de login
                LoginButton(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),

                const SizedBox(height: 24),

                // Divisor
                const DividerWidget(),

                const SizedBox(height: 24),

                // Link para registro
                const RegisterLinkWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget para o cabeçalho da tela de login
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.restaurant_menu, size: 40),
        ),
        const SizedBox(height: 24),
        Text(
          'NutriPlan',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Bem-vindo de volta!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

/// Widget para o campo de email
class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final LoginViewModel viewModel;

  const EmailField({
    super.key,
    required this.controller,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: viewModel.validateEmail,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Digite seu email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Widget para o campo de senha
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final LoginViewModel viewModel;

  const PasswordField({
    super.key,
    required this.controller,
    required this.viewModel,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      validator: widget.viewModel.validatePassword,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Widget para o botão de login
class LoginButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final isLoading = loginState is LoginLoading;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (formKey.currentState?.validate() ?? false) {
                  await viewModel.executeLogin(
                    LoginCommand(
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'Entrar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}

/// Widget para lembrar senha e esqueci senha
class RememberAndForgotWidget extends ConsumerStatefulWidget {
  final TextEditingController emailController;

  const RememberAndForgotWidget({super.key, required this.emailController});

  @override
  ConsumerState<RememberAndForgotWidget> createState() =>
      _RememberAndForgotWidgetState();
}

class _RememberAndForgotWidgetState
    extends ConsumerState<RememberAndForgotWidget> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
          ],
        ),
        TextButton(
          onPressed: () async {
            if (widget.emailController.text.isNotEmpty) {
              final viewModel = ref.read(loginViewModelProvider.notifier);
              await viewModel.executeForgotPassword(
                ForgotPasswordCommand(widget.emailController.text),
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email de recuperação enviado!'),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Digite seu email primeiro')),
              );
            }
          },
          child: const Text('Esqueci minha senha'),
        ),
      ],
    );
  }
}

/// Widget para link de registro
class RegisterLinkWidget extends StatelessWidget {
  const RegisterLinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Não tem uma conta? '),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          child: const Text(
            'Cadastre-se',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// Widget para divisor com texto
class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('ou', style: Theme.of(context).textTheme.bodyMedium),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
