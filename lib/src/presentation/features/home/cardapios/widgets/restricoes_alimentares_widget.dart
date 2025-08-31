import 'package:flutter/material.dart';
import '../../../../../domain/models/perfil_familiar.dart';

class RestricaoAlimentarWidget extends StatelessWidget {
  final Set<RestricaoAlimentar> restricoesSelecionadas;
  final ValueChanged<Set<RestricaoAlimentar>> onChanged;

  const RestricaoAlimentarWidget({
    super.key,
    required this.restricoesSelecionadas,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Restrições Alimentares:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RestricaoAlimentar.values.map((restricao) {
            final isSelected = restricoesSelecionadas.contains(restricao);
            return FilterChip(
              label: Text(restricao.displayName),
              selected: isSelected,
              onSelected: (selected) {
                final novasRestricoes = Set<RestricaoAlimentar>.from(restricoesSelecionadas);
                if (selected) {
                  novasRestricoes.add(restricao);
                } else {
                  novasRestricoes.remove(restricao);
                }
                onChanged(novasRestricoes);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}