import 'package:flutter/material.dart';
import '../../../../../domain/models/menu.dart';

class SeletorDiaWidget extends StatelessWidget {
  final DiaSemana diaSelecionado;
  final ValueChanged<DiaSemana> onDiaChanged;
  final ScrollController? scrollController;

  const SeletorDiaWidget({
    super.key,
    required this.diaSelecionado,
    required this.onDiaChanged,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: DiaSemana.values.map((dia) {
          final isSelected = dia == diaSelecionado;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(dia.displayName.split('-').first),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onDiaChanged(dia);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}