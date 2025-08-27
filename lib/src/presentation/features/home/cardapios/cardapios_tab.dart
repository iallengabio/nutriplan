import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home_viewmodel.dart';

class CardapiosTab extends ConsumerWidget {
  const CardapiosTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meus Cardápios',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildCardapiosList(context, homeState, homeViewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildCardapiosList(BuildContext context, HomeState homeState, HomeViewModel homeViewModel) {
    if (homeState.cardapios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum cardápio criado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque em "Novo" para criar seu primeiro cardápio',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: homeState.cardapios.length,
      itemBuilder: (context, index) {
        final cardapio = homeState.cardapios[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.restaurant_menu,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            title: Text(cardapio),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Criado em ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                Text('${7} refeições planejadas'),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      Icon(Icons.copy),
                      SizedBox(width: 8),
                      Text('Duplicar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Excluir', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteCardapioDialog(context, cardapio, homeViewModel);
                }
                // TODO: Implementar outras ações
              },
            ),
            onTap: () {
              // TODO: Navegar para editar cardápio
            },
          ),
        );
      },
    );
  }

  void _showDeleteCardapioDialog(BuildContext context, String cardapio, HomeViewModel homeViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Cardápio'),
        content: Text('Tem certeza que deseja excluir o cardápio "$cardapio"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              homeViewModel.removerCardapio(cardapio);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cardápio "$cardapio" excluído!'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}