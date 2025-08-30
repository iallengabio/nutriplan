import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di.dart';
import 'menu_viewmodel.dart';
import 'editar_cardapio_screen.dart';

class CardapiosTab extends ConsumerStatefulWidget {
  const CardapiosTab({super.key});

  @override
  ConsumerState<CardapiosTab> createState() => _CardapiosTabState();
}

class _CardapiosTabState extends ConsumerState<CardapiosTab> {
  @override
  void initState() {
    super.initState();
    // Carrega os cardápios quando a aba é inicializada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuViewModelProvider.notifier).carregarMenus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuViewModelProvider);
    final menuViewModel = ref.read(menuViewModelProvider.notifier);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meus Cardápios',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (menuState.menus.isNotEmpty)
                IconButton(
                  onPressed: () => menuViewModel.carregarMenus(),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Atualizar',
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (menuState.errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      menuState.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => menuViewModel.limparErro(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _buildCardapiosList(context, menuState, menuViewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildCardapiosList(BuildContext context, MenuState menuState, MenuViewModel menuViewModel) {
    if (menuState.isLoading && menuState.menus.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (menuState.menus.isEmpty) {
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
              'Toque no botão "+" para criar seu primeiro cardápio',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () => menuViewModel.carregarMenus(),
      child: ListView.builder(
        itemCount: menuState.menus.length,
        itemBuilder: (context, index) {
          final menu = menuState.menus[index];
          final totalRefeicoes = menu.refeicoesPorDia.values
              .fold<int>(0, (total, refeicoes) => total + refeicoes.length);
          
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: menu.isFavorito 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  menu.isFavorito ? Icons.favorite : Icons.restaurant_menu,
                  color: menu.isFavorito 
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              title: Text(
                menu.nome,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Criado em ${_formatarData(menu.dataCriacao)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '$totalRefeicoes refeições planejadas',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (menu.observacoes?.isNotEmpty == true)
                    Text(
                      menu.observacoes!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'favorite',
                    child: Row(
                      children: [
                        Icon(menu.isFavorito ? Icons.favorite_border : Icons.favorite),
                        const SizedBox(width: 8),
                        Text(menu.isFavorito ? 'Remover dos favoritos' : 'Adicionar aos favoritos'),
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
                    case 'favorite':
                      menuViewModel.toggleFavorito(menu.id);
                      break;

                    case 'duplicate':
                      _duplicarCardapio(context, menu, menuViewModel);
                      break;
                    case 'delete':
                      _showDeleteCardapioDialog(context, menu, menuViewModel);
                      break;
                  }
                },
              ),
              onTap: () {
                menuViewModel.selecionarMenu(menu);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditarCardapioScreen(
                      menu: menu,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDeleteCardapioDialog(BuildContext context, menu, MenuViewModel menuViewModel) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir Cardápio'),
        content: Text('Tem certeza que deseja excluir o cardápio "${menu.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              // Salva as referências necessárias antes da operação assíncrona
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final colorScheme = Theme.of(context).colorScheme;
              final menuNome = menu.nome;
              
              Navigator.of(dialogContext).pop();
              await menuViewModel.removerMenu(menu.id);
              
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Cardápio "$menuNome" excluído!'),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _duplicarCardapio(BuildContext context, menu, MenuViewModel menuViewModel) async {
    await menuViewModel.duplicarMenu(menu.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cardápio "${menu.nome}" duplicado!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}