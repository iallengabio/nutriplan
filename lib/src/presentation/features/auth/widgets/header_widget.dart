import 'package:flutter/material.dart';

/// Widget para o cabeçalho da tela de login
class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;

  const HeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Icon(icon, size: 40),
          ),
        if (icon != null) const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}