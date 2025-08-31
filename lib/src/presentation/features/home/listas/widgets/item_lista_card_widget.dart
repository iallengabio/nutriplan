import 'package:flutter/material.dart';
import '../../../../../domain/models/shopping_list.dart';

class ItemListaCardWidget extends StatelessWidget {
  final ShoppingItem item;
  final int index;
  final VoidCallback? onToggleComprado;
  final VoidCallback? onEditar;
  final VoidCallback? onRemover;
  final bool isEditable;

  const ItemListaCardWidget({
    super.key,
    required this.item,
    required this.index,
    this.onToggleComprado,
    this.onEditar,
    this.onRemover,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(
        16,
        index == 0 ? 0 : 4,
        16,
        4,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: isEditable
            ? Checkbox(
                value: item.comprado,
                onChanged: onToggleComprado != null ? (_) => onToggleComprado!() : null,
              )
            : null,
        title: Text(
          item.nome,
          style: TextStyle(
            decoration: item.comprado ? TextDecoration.lineThrough : null,
            color: item.comprado ? Colors.grey : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quantidade: ${item.quantidade}',
                style: TextStyle(
                  color: item.comprado
                      ? Colors.grey
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (item.categoria?.isNotEmpty == true)
                Text(
                  'Categoria: ${item.categoria}',
                  style: TextStyle(
                    color: item.comprado
                        ? Colors.grey
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              if (item.observacoes?.isNotEmpty == true)
                Text(
                  'Obs: ${item.observacoes}',
                  style: TextStyle(
                    color: item.comprado
                        ? Colors.grey
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        trailing: isEditable
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEditar != null)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEditar,
                      tooltip: 'Editar item',
                    ),
                  if (onRemover != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).colorScheme.error,
                      onPressed: onRemover,
                      tooltip: 'Remover item',
                    ),
                ],
              )
            : null,
      ),
    );
  }
}