import 'package:flutter/material.dart';
import '../../../../../core/extensions/date_extensions.dart';
import '../../../../../domain/models/shopping_list.dart';

class ListaComprasCardWidget extends StatelessWidget {
  final ShoppingList lista;
  final VoidCallback onTap;
  final Function(String) onEdit;
  final Function(String) onShare;
  final Function(String) onDuplicate;
  final Function(String) onDelete;

  const ListaComprasCardWidget({
    super.key,
    required this.lista,
    required this.onTap,
    required this.onEdit,
    required this.onShare,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                onEdit(lista.id);
                break;
              case 'share':
                onShare(lista.id);
                break;
              case 'duplicate':
                onDuplicate(lista.id);
                break;
              case 'delete':
                onDelete(lista.id);
                break;
            }
          },
        ),
        onTap: onTap,
      ),
    );
  }
}