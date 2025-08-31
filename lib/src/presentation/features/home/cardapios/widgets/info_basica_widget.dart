import 'package:flutter/material.dart';
import '../../../../../domain/models/menu.dart';

class InfoBasicaWidget extends StatelessWidget {
  final TextEditingController nomeController;
  final Menu menu;
  final ValueChanged<String> onNomeChanged;
  final Widget? infoPerfilWidget;

  const InfoBasicaWidget({
    super.key,
    required this.nomeController,
    required this.menu,
    required this.onNomeChanged,
    this.infoPerfilWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações Básicas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Cardápio',
                border: OutlineInputBorder(),
              ),
              onChanged: onNomeChanged,
            ),
            if (infoPerfilWidget != null) ...[
              const SizedBox(height: 16),
              infoPerfilWidget!,
            ]
          ],
        ),
      ),
    );
  }
}