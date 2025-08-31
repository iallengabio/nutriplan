import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../login/login_viewmodel.dart';

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