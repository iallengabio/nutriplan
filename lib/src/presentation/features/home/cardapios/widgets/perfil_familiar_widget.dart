import 'package:flutter/material.dart';
import '../../../../../domain/models/perfil_familiar.dart';
import 'counter_widget.dart';
import 'restricoes_alimentares_widget.dart';

class PerfilFamiliarWidget extends StatelessWidget {
  final int numeroAdultos;
  final int numeroCriancas;
  final Set<RestricaoAlimentar> restricoesAlimentares;
  final ValueChanged<int> onAdultosChanged;
  final ValueChanged<int> onCriancasChanged;
  final ValueChanged<Set<RestricaoAlimentar>> onRestricaoChanged;

  const PerfilFamiliarWidget({
    super.key,
    required this.numeroAdultos,
    required this.numeroCriancas,
    required this.restricoesAlimentares,
    required this.onAdultosChanged,
    required this.onCriancasChanged,
    required this.onRestricaoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perfil Familiar',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Número de adultos
        CounterWidget(
          label: 'Número de adultos:',
          value: numeroAdultos,
          minValue: 1,
          maxValue: 10,
          onChanged: onAdultosChanged,
        ),
        
        const SizedBox(height: 16),
        
        // Número de crianças
        CounterWidget(
          label: 'Número de crianças:',
          value: numeroCriancas,
          minValue: 0,
          maxValue: 10,
          onChanged: onCriancasChanged,
        ),
        
        const SizedBox(height: 16),
        
        // Restrições alimentares
        RestricaoAlimentarWidget(
          restricoesSelecionadas: restricoesAlimentares,
          onChanged: onRestricaoChanged,
        ),
      ],
    );
  }
}