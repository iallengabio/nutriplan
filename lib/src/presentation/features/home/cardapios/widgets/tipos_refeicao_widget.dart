import 'package:flutter/material.dart';
import '../../../../../domain/models/refeicao.dart';

class TiposRefeicaoWidget extends StatelessWidget {
  final Set<TipoRefeicao> tiposSelecionados;
  final ValueChanged<Set<TipoRefeicao>> onChanged;
  final bool showError;

  const TiposRefeicaoWidget({
    super.key,
    required this.tiposSelecionados,
    required this.onChanged,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipos de Refeição',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecione quais refeições deseja incluir no cardápio:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TipoRefeicao.values.map((tipo) {
            final isSelected = tiposSelecionados.contains(tipo);
            return FilterChip(
              label: Text(tipo.displayName),
              selected: isSelected,
              onSelected: (selected) {
                final novosTipos = Set<TipoRefeicao>.from(tiposSelecionados);
                if (selected) {
                  novosTipos.add(tipo);
                } else {
                  novosTipos.remove(tipo);
                }
                onChanged(novosTipos);
              },
            );
          }).toList(),
        ),
        if (showError && tiposSelecionados.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Selecione pelo menos um tipo de refeição',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}