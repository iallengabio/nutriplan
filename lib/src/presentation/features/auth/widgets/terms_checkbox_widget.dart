import 'package:flutter/material.dart';

class TermsCheckboxWidget extends StatelessWidget {
  final bool acceptTerms;
  final ValueChanged<bool> onChanged;

  const TermsCheckboxWidget({
    super.key,
    required this.acceptTerms,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: acceptTerms,
          onChanged: (value) => onChanged(value ?? false),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!acceptTerms),
            child: Text.rich(
              TextSpan(
                text: 'Eu aceito os ',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                children: [
                  TextSpan(
                    text: 'Termos de Uso',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' e '),
                  TextSpan(
                    text: 'Política de Privacidade',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}