import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../di.dart';
import '../../../profile/family_profile_page.dart';
import 'perfil_info_item_widget.dart';

class PerfilFamiliarInfoWidget extends ConsumerWidget {
  const PerfilFamiliarInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyProfileState = ref.watch(familyProfileViewModelProvider);
    final perfil = familyProfileState.perfil;
    
    if (perfil == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.family_restroom_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 8),
              Text(
                'Perfil Familiar não configurado',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Configure seu perfil familiar nas configurações para gerar cardápios personalizados',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FamilyProfilePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('Configurar Perfil'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.family_restroom,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Perfil Familiar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FamilyProfilePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: PerfilInfoItemWidget(
                    label: 'Adultos',
                    value: perfil.numeroAdultos.toString(),
                    icon: Icons.person,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PerfilInfoItemWidget(
                    label: 'Crianças',
                    value: perfil.numeroCriancas.toString(),
                    icon: Icons.child_care,
                  ),
                ),
              ],
            ),
            if (perfil.restricoesAlimentares.isNotEmpty) ...[
              const SizedBox(height: 12),
              PerfilInfoItemWidget(
                label: 'Restrições',
                value: perfil.restricoesAlimentares.map((r) => r.displayName).join(', '),
                icon: Icons.no_food,
              ),
            ],
            if (perfil.observacoesAdicionais?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              PerfilInfoItemWidget(
                label: 'Observações',
                value: perfil.observacoesAdicionais!,
                icon: Icons.note,
              ),
            ],
          ],
        ),
      ),
    );
  }
}