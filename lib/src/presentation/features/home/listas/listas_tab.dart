import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home_viewmodel.dart';

class ListasTab extends ConsumerWidget {
  const ListasTab({super.key});

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
            'Minhas Listas de Compras',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildListasList(context, homeState, homeViewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildListasList(BuildContext context, HomeState homeState, HomeViewModel homeViewModel) {
    if (homeState.listas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma lista criada',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque em "Nova" para criar sua primeira lista',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: homeState.listas.length,
      itemBuilder: (context, index) {
        final lista = homeState.listas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            title: Text(lista),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Criada em ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                Text('${12} itens na lista'),
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
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8),
                      Text('Compartilhar'),
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
                  _showDeleteListaDialog(context, lista, homeViewModel);
                }
                // TODO: Implementar outras ações
              },
            ),
            onTap: () {
              // TODO: Navegar para editar lista
            },
          ),
        );
      },
    );
  }

  void _showDeleteListaDialog(BuildContext context, String lista, HomeViewModel homeViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Lista'),
        content: Text('Tem certeza que deseja excluir a lista "$lista"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              homeViewModel.removerLista(lista);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lista "$lista" excluída!'),
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