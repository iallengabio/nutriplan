import 'package:flutter/material.dart';

class ObservacoesWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const ObservacoesWidget({
    super.key,
    required this.controller,
    this.title = 'Observações Adicionais',
    this.hintText = 'Ex: Preferências, ingredientes específicos, etc.',
    this.onChanged,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          maxLines: maxLines,
          onChanged: onChanged,
        ),
      ],
    );
  }
}