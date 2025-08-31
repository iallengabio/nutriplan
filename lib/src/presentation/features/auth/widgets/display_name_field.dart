import 'package:flutter/material.dart';

/// Widget para o campo de nome de exibição
class DisplayNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final bool isRequired;

  const DisplayNameField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText,
    this.hintText,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelText = labelText ?? (isRequired ? 'Nome' : 'Nome (opcional)');
    final effectiveHintText = hintText ?? 'Digite seu nome';

    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: validator,
      decoration: InputDecoration(
        labelText: effectiveLabelText,
        hintText: effectiveHintText,
        prefixIcon: const Icon(Icons.person_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}