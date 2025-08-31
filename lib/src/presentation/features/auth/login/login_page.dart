import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_viewmodel.dart';
import '../widgets/header_widget.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/divider_widget.dart';
import '../widgets/login_button.dart';
import '../widgets/remember_and_forgot_widget.dart';
import '../widgets/register_link_widget.dart';

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
                const HeaderWidget(
                  title: 'NutriPlan',
                  subtitle: 'Bem-vindo de volta!',
                  icon: Icons.restaurant_menu,
                ),

                const SizedBox(height: 48),

                // Campos de entrada
                EmailField(
                  controller: _emailController,
                  validator: loginViewModel.validateEmail,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _passwordController,
                  validator: loginViewModel.validatePassword,
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
