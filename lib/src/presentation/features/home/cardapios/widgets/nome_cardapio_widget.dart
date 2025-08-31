import 'package:flutter/material.dart';

class NomeCardapioWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final String? hintText;
  final bool isRequired;
  final String? Function(String?)? validator;

  const NomeCardapioWidget({
    super.key,
    required this.controller,
    this.title,
    this.hintText,
    this.isRequired = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText ?? 'Digite o nome do cardápio',
            border: const OutlineInputBorder(),
            labelText: isRequired ? '${title ?? 'Nome'} *' : title,
          ),
          validator: validator,
        ),
      ],
    );
  }
}