import 'package:flutter/material.dart';
import '../../../../../core/extensions/date_extensions.dart';
import '../../../../../domain/models/menu.dart';
import '../menu_viewmodel.dart';
import '../editar_cardapio_screen.dart';

/// Widget que representa um card de cardápio na lista
class CardapioCardWidget extends StatelessWidget {
  final Menu menu;
  final MenuViewModel menuViewModel;

  const CardapioCardWidget({
    super.key,
    required this.menu,
    required this.menuViewModel,
  });

  @override
  Widget build(BuildContext context) {
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
              'Criado em ${menu.dataCriacao.formatarDataBrasileira()}',
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
          onSelected: (value) => _handleMenuAction(context, value),
        ),
        onTap: () => _navigateToEditScreen(context),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'favorite':
        menuViewModel.toggleFavorito(menu.id);
        break;
      case 'duplicate':
        _duplicarCardapio(context);
        break;
      case 'delete':
        _showDeleteCardapioDialog(context);
        break;
    }
  }

  void _navigateToEditScreen(BuildContext context) {
    menuViewModel.selecionarMenu(menu);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditarCardapioScreen(
          menu: menu,
        ),
      ),
    );
  }

  void _showDeleteCardapioDialog(BuildContext context) {
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

              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('Cardápio "$menuNome" excluído!'),
                  backgroundColor: colorScheme.error,
                ),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _duplicarCardapio(BuildContext context) async {
    await menuViewModel.duplicarMenu(menu.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cardápio "${menu.nome}" duplicado!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }
}