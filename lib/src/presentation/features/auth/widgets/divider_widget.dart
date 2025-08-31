import 'package:flutter/material.dart';

/// Widget para divisor com texto
class DividerWidget extends StatelessWidget {
  final String text;

  const DividerWidget({
    super.key,
    this.text = 'ou',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}