import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/perfil_familiar.dart';
import '../../../di.dart';
import 'family_profile_viewmodel.dart';

class FamilyProfilePage extends ConsumerStatefulWidget {
  const FamilyProfilePage({super.key});

  @override
  ConsumerState<FamilyProfilePage> createState() => _FamilyProfilePageState();
}

class _FamilyProfilePageState extends ConsumerState<FamilyProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(familyProfileViewModelProvider.notifier).carregarPerfil();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<FamilyProfileState>(familyProfileViewModelProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final state = ref.watch(familyProfileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Familiar'),
        centerTitle: true,
        actions: [
          if (state.hasChanges)
            TextButton(
              onPressed: state.isSaving
                  ? null
                  : () async {
                      final success = await ref
                          .read(familyProfileViewModelProvider.notifier)
                          .salvarPerfil();
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Perfil salvo com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
              child: state.isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar'),
            ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(FamilyProfileState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.perfil == null) {
      return _buildEmptyState();
    }

    return _buildProfileContent(state.perfil!);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.family_restroom,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum perfil familiar encontrado',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Crie um perfil para personalizar seus cardápios',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              // TODO: Implementar criação de perfil padrão
              // await ref
              //     .read(familyProfileViewModelProvider.notifier)
              //     .criarPerfilPadrao(userId);
            },
            icon: const Icon(Icons.add),
            label: const Text('Criar Perfil'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(PerfilFamiliar perfil) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildFamilySizeSection(perfil),
        const SizedBox(height: 24),
        _buildDietaryRestrictionsSection(perfil),
        const SizedBox(height: 24),
        _buildAdditionalNotesSection(perfil),
        const SizedBox(height: 32),
        _buildProfileSummary(perfil),
      ],
    );
  }

  Widget _buildProfileSummary(PerfilFamiliar perfil) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo do Perfil',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text('Total de pessoas: ${perfil.totalPessoas}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  perfil.temRestricoes
                      ? 'Com restrições alimentares'
                      : 'Sem restrições alimentares',
                ),
              ],
            ),
            if (perfil.dataUltimaAtualizacao != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.update,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Última atualização: ${_formatDate(perfil.dataUltimaAtualizacao!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildFamilySizeSection(PerfilFamiliar perfil) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tamanho da Família',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adultos',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: perfil.numeroAdultos > 1
                                ? () => ref
                                    .read(familyProfileViewModelProvider.notifier)
                                    .atualizarNumeroAdultos(perfil.numeroAdultos - 1)
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            perfil.numeroAdultos.toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            onPressed: () => ref
                                .read(familyProfileViewModelProvider.notifier)
                                .atualizarNumeroAdultos(perfil.numeroAdultos + 1),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crianças',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: perfil.numeroCriancas > 0
                                ? () => ref
                                    .read(familyProfileViewModelProvider.notifier)
                                    .atualizarNumeroCriancas(perfil.numeroCriancas - 1)
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            perfil.numeroCriancas.toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            onPressed: () => ref
                                .read(familyProfileViewModelProvider.notifier)
                                .atualizarNumeroCriancas(perfil.numeroCriancas + 1),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaryRestrictionsSection(PerfilFamiliar perfil) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restrições Alimentares',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: RestricaoAlimentar.values.map((restricao) {
                final isSelected = perfil.restricoesAlimentares.contains(restricao);
                return FilterChip(
                   label: Text(restricao.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      ref
                          .read(familyProfileViewModelProvider.notifier)
                          .adicionarRestricao(restricao);
                    } else {
                      ref
                          .read(familyProfileViewModelProvider.notifier)
                          .removerRestricao(restricao);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalNotesSection(PerfilFamiliar perfil) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Observações Adicionais',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: perfil.observacoesAdicionais ?? '',
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Adicione observações sobre preferências alimentares, alergias específicas, etc.',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref
                    .read(familyProfileViewModelProvider.notifier)
                    .atualizarObservacoes(value.isEmpty ? null : value);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}