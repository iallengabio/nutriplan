import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_viewmodel.dart';
import '../widgets/header_widget.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/display_name_field.dart';
import '../widgets/terms_checkbox_widget.dart';
import '../widgets/register_button_widget.dart';
import '../widgets/login_link_widget.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerViewModelProvider);
    final registerViewModel = ref.read(registerViewModelProvider.notifier);

    // Escuta mudanças de estado para navegação
    ref.listen<RegisterState>(registerViewModelProvider, (previous, next) {
      if (next is RegisterSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Conta criada com sucesso!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        // Volta para a tela de login
        Navigator.of(context).pop();
      } else if (next is RegisterError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const HeaderWidget(
                  title: 'Criar Conta',
                  subtitle: 'Preencha os dados para criar sua conta',
                ),

                const SizedBox(height: 32),

                // Campos de entrada
                DisplayNameField(
                  controller: _displayNameController,
                  validator: registerViewModel.validateDisplayName,
                ),
                const SizedBox(height: 16),
                EmailField(
                  controller: _emailController,
                  validator: registerViewModel.validateEmail,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _passwordController,
                  validator: registerViewModel.validatePassword,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _confirmPasswordController,
                  validator: (value) => registerViewModel
                      .validateConfirmPassword(value, _passwordController.text),
                  labelText: 'Confirmar Senha',
                  hintText: 'Digite sua senha novamente',
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: () => _handleRegister(registerViewModel),
                ),

                const SizedBox(height: 16),

                // Aceitar termos
                TermsCheckboxWidget(
                  acceptTerms: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Botão de registro
                RegisterButtonWidget(
                  state: registerState,
                  acceptTerms: _acceptTerms,
                  onPressed: () => _handleRegister(registerViewModel),
                ),

                const SizedBox(height: 24),

                // Link para login
                const LoginLinkWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister(RegisterViewModel viewModel) {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Você deve aceitar os termos de uso'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      final command = RegisterCommand(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        displayName: _displayNameController.text.trim().isEmpty
            ? null
            : _displayNameController.text.trim(),
      );
      viewModel.executeRegister(command);
    }
  }
}
