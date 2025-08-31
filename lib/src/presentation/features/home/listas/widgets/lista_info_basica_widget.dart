import 'package:flutter/material.dart';

class ListaInfoBasicaWidget extends StatelessWidget {
  final TextEditingController nomeController;
  final TextEditingController observacoesController;

  const ListaInfoBasicaWidget({
    super.key,
    required this.nomeController,
    required this.observacoesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
            'Informações Básicas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome da lista *',
              hintText: 'Ex: Lista do supermercado',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor, insira um nome para a lista';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: observacoesController,
            decoration: const InputDecoration(
              labelText: 'Observações',
              hintText: 'Ex: Lista para a semana',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
    );
  }
}