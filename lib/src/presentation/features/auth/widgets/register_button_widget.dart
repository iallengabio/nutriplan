import 'package:flutter/material.dart';
import '../register/register_viewmodel.dart';

class RegisterButtonWidget extends StatelessWidget {
  final RegisterState state;
  final VoidCallback onPressed;
  final bool acceptTerms;

  const RegisterButtonWidget({
    super.key,
    required this.state,
    required this.onPressed,
    required this.acceptTerms,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = state is RegisterLoading;
    
    return ElevatedButton(
      onPressed: (isLoading || !acceptTerms) ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
                ),
            )
          : const Text(
              'Criar Conta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}