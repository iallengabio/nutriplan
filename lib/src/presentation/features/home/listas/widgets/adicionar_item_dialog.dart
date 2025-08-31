import 'package:flutter/material.dart';
import '../../../../../domain/models/shopping_list.dart';

class AdicionarItemDialog extends StatefulWidget {
  final ShoppingItem? item; // null para adicionar, preenchido para editar
  final Function(ShoppingItem) onSalvar;

  const AdicionarItemDialog({
    super.key,
    this.item,
    required this.onSalvar,
  });

  @override
  State<AdicionarItemDialog> createState() => _AdicionarItemDialogState();
}

class _AdicionarItemDialogState extends State<AdicionarItemDialog> {
  late final TextEditingController _nomeController;
  late final TextEditingController _quantidadeController;
  late final TextEditingController _categoriaController;
  late final TextEditingController _observacoesController;

  bool get isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.item?.nome ?? '');
    _quantidadeController = TextEditingController(text: widget.item?.quantidade ?? '');
    _categoriaController = TextEditingController(text: widget.item?.categoria ?? '');
    _observacoesController = TextEditingController(text: widget.item?.observacoes ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    _categoriaController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar Item' : 'Adicionar Item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do item *',
                hintText: 'Ex: Arroz',
              ),
              autofocus: !isEditing,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantidadeController,
              decoration: const InputDecoration(
                labelText: 'Quantidade *',
                hintText: 'Ex: 1kg',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _categoriaController,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                hintText: 'Ex: Grãos',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _observacoesController,
              decoration: const InputDecoration(
                labelText: 'Observações',
                hintText: 'Ex: Marca específica',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _salvarItem,
          child: Text(isEditing ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }

  void _salvarItem() {
    final nome = _nomeController.text.trim();
    final quantidade = _quantidadeController.text.trim();

    if (nome.isEmpty || quantidade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome e quantidade são obrigatórios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final item = ShoppingItem(
      id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      quantidade: quantidade,
      categoria: _categoriaController.text.trim().isEmpty ? null : _categoriaController.text.trim(),
      observacoes: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
      comprado: widget.item?.comprado ?? false,
    );

    widget.onSalvar(item);
    Navigator.of(context).pop();
  }
}