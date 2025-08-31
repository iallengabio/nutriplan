import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../di.dart';
import '../../shopping/pages/create_shopping_list_from_menu_page.dart';
import 'create_shopping_list_page.dart';
import 'edit_shopping_list_page.dart';
import 'shopping_list_viewmodel.dart';
import 'widgets/delete_confirmation_dialog.dart';

class ListasTab extends ConsumerStatefulWidget {
  const ListasTab({super.key});

  @override
  ConsumerState<ListasTab> createState() => _ListasTabState();
}

class _ListasTabState extends ConsumerState<ListasTab> {
  @override
  void initState() {
    super.initState();
    // Carregar listas ao inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shoppingListViewModelProvider.notifier).carregarListasDeCompras();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListState = ref.watch(shoppingListViewModelProvider);
    final shoppingListViewModel = ref.read(shoppingListViewModelProvider.notifier);
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minhas Listas de Compras',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildListasList(context, shoppingListState, shoppingListViewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListasList(BuildContext context, ShoppingListState state, ShoppingListViewModel viewModel) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar listas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => viewModel.carregarListasDeCompras(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.shoppingLists?.isEmpty ?? true) {
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
    
    return RefreshIndicator(
      onRefresh: () async => viewModel.carregarListasDeCompras(),
      child: ListView.builder(
        itemCount: state.shoppingLists!.length,
        itemBuilder: (context, index) {
          final lista = state.shoppingLists![index];
          final totalItens = lista.itens.length;
          final itensComprados = lista.itens.where((item) => item.comprado).length;
          
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
              title: Text(lista.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Criada em ${lista.dataCriacao.formatarDataBrasileira()}'),
                  Text('$itensComprados/$totalItens itens comprados'),
                  if (totalItens > 0)
                    LinearProgressIndicator(
                      value: itensComprados / totalItens,
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    ),
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
                  switch (value) {
                    case 'edit':
                      _navegarParaEdicao(context, lista);
                      break;
                    case 'share':
                      _compartilharLista(context, lista, viewModel);
                      break;
                    case 'duplicate':
                      _duplicarLista(context, lista.id, viewModel);
                      break;
                    case 'delete':
                      _showDeleteListaDialog(context, lista, viewModel);
                      break;
                  }
                },
              ),
              onTap: () {
                _navegarParaEdicao(context, lista);
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreateListDialog(BuildContext context, ShoppingListViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Lista de Compras'),
        content: const Text('Como você gostaria de criar a lista?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateShoppingListFromMenuPage(),
                ),
              );
            },
            child: const Text('Baseada em Cardápio'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateShoppingListPage(),
                ),
              );
            },
            child: const Text('Lista Manual'),
          ),
        ],
      ),
    );
  }

  void _showDeleteListaDialog(BuildContext context, dynamic lista, ShoppingListViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
         title: 'Excluir Lista',
         content: 'Tem certeza que deseja excluir a lista "${lista.nome}"?',
         onConfirm: () {
           viewModel.removerListaDeCompras(lista.id);
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Lista "${lista.nome}" excluída!'),
               backgroundColor: Theme.of(context).colorScheme.error,
             ),
           );
         },
       ),
    );
  }

  void _navegarParaEdicao(BuildContext context, dynamic lista) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditShoppingListPage(shoppingList: lista),
      ),
    );
  }

  void _duplicarLista(BuildContext context, String listaId, ShoppingListViewModel viewModel) {
    viewModel.duplicarListaDeCompras(listaId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lista duplicada com sucesso!'),
      ),
    );
  }



  void _compartilharLista(BuildContext context, dynamic lista, ShoppingListViewModel viewModel) {
    viewModel.compartilharLista(lista);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compartilhando lista...'),
      ),
    );
  }

  void _importarLista(BuildContext context, ShoppingListViewModel viewModel) async {
    try {
      await viewModel.importarLista();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lista importada com sucesso!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao importar lista: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}