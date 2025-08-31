import 'package:flutter/material.dart';
import '../../../../../core/extensions/date_extensions.dart';
import '../../../../../domain/models/menu.dart';

class InfoPerfilWidget extends StatelessWidget {
  final Menu menu;

  const InfoPerfilWidget({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações do Cardápio',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text('Criado em: ${menu.dataCriacao.formatarDataBrasileira()}'),
          ],
        ),
        if (menu.dataUltimaEdicao != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.edit, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text('Última edição: ${menu.dataUltimaEdicao!.formatarDataBrasileira()}'),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.restaurant, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text('Total de refeições: ${menu.totalRefeicoes}'),
          ],
        ),
      ],
    );
  }
}