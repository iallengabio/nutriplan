import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di.dart';
import 'shopping_list_viewmodel.dart';
import '../../../../domain/models/shopping_list.dart';

class EditShoppingListPage extends ConsumerStatefulWidget {
  final ShoppingList shoppingList;
  
  const EditShoppingListPage({
    super.key,
    required this.shoppingList,
  });

  @override
  ConsumerState<EditShoppingListPage> createState() => _EditShoppingListPageState();
}

class _EditShoppingListPageState extends ConsumerState<EditShoppingListPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _observacoesController;
  late List<ShoppingItem> _itens;
  final _itemNomeController = TextEditingController();
  final _itemQuantidadeController = TextEditingController();
  final _itemCategoriaController = TextEditingController();
  final _itemObservacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.shoppingList.nome);
    _observacoesController = TextEditingController(text: widget.shoppingList.observacoes ?? '');
    _itens = List.from(widget.shoppingList.itens);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _observacoesController.dispose();
    _itemNomeController.dispose();
    _itemQuantidadeController.dispose();
    _itemCategoriaController.dispose();
    _itemObservacoesController.dispose();
    super.dispose();
  }

  void _adicionarItem() {
    if (_itemNomeController.text.trim().isEmpty ||
        _itemQuantidadeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome e quantidade são obrigatórios'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final novoItem = ShoppingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _itemNomeController.text.trim(),
      quantidade: _itemQuantidadeController.text.trim(),
      categoria: _itemCategoriaController.text.trim().isEmpty
          ? null
          : _itemCategoriaController.text.trim(),
      observacoes: _itemObservacoesController.text.trim().isEmpty
          ? null
          : _itemObservacoesController.text.trim(),
      comprado: false,
    );

    setState(() {
      _itens.add(novoItem);
    });

    // Limpar campos
    _itemNomeController.clear();
    _itemQuantidadeController.clear();
    _itemCategoriaController.clear();
    _itemObservacoesController.clear();
  }

  void _removerItem(int index) {
    setState(() {
      _itens.removeAt(index);
    });
  }

  void _toggleItemComprado(int index) {
    setState(() {
      _itens[index] = _itens[index].copyWith(
        comprado: !_itens[index].comprado,
      );
    });
  }

  void _editarItem(int index) {
    final item = _itens[index];
    
    // Preencher os controladores com os dados do item
    _itemNomeController.text = item.nome;
    _itemQuantidadeController.text = item.quantidade;
    _itemCategoriaController.text = item.categoria ?? '';
    _itemObservacoesController.text = item.observacoes ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemNomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do item *',
                  hintText: 'Ex: Arroz',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _itemQuantidadeController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade *',
                  hintText: 'Ex: 1kg',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _itemCategoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  hintText: 'Ex: Grãos',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _itemObservacoesController,
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
            onPressed: () {
              Navigator.of(context).pop();
              // Limpar campos
              _itemNomeController.clear();
              _itemQuantidadeController.clear();
              _itemCategoriaController.clear();
              _itemObservacoesController.clear();
            },
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (_itemNomeController.text.trim().isEmpty ||
                  _itemQuantidadeController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nome e quantidade são obrigatórios'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              setState(() {
                _itens[index] = _itens[index].copyWith(
                  nome: _itemNomeController.text.trim(),
                  quantidade: _itemQuantidadeController.text.trim(),
                  categoria: _itemCategoriaController.text.trim().isEmpty
                      ? null
                      : _itemCategoriaController.text.trim(),
                  observacoes: _itemObservacoesController.text.trim().isEmpty
                      ? null
                      : _itemObservacoesController.text.trim(),
                );
              });

              Navigator.of(context).pop();
              // Limpar campos
              _itemNomeController.clear();
              _itemQuantidadeController.clear();
              _itemCategoriaController.clear();
              _itemObservacoesController.clear();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _salvarLista() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = ref.read(shoppingListViewModelProvider.notifier);

    // Criar lista atualizada
    final listaAtualizada = widget.shoppingList.copyWith(
      nome: _nomeController.text.trim(),
      observacoes: _observacoesController.text.trim().isEmpty
          ? null
          : _observacoesController.text.trim(),
      itens: _itens,
      dataUltimaEdicao: DateTime.now(),
    );

    // Salvar a lista usando o repository
    final result = await ref.read(shoppingListRepositoryProvider).atualizarListaCompras(listaAtualizada);
    
    result.fold(
      (_) {
        // Sucesso - atualizar o estado local e voltar para a tela anterior
        viewModel.carregarListasDeCompras();
        
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lista "${listaAtualizada.nome}" atualizada com sucesso!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      },
      (error) {
        // Erro ao salvar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar: ${error.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Lista de Compras'),
        actions: [
          IconButton(
            onPressed: _salvarLista,
            icon: const Icon(Icons.save),
            tooltip: 'Salvar alterações',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAdicionarItemDialog(),
        tooltip: 'Adicionar item',
        child: const Icon(Icons.add),
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            // Informações da lista
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações da Lista',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome da lista *',
                          hintText: 'Ex: Compras da semana',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _observacoesController,
                        decoration: const InputDecoration(
                          labelText: 'Observações',
                          hintText: 'Observações adicionais sobre a lista',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      // Informações do menu associado
                      if (widget.shoppingList.menuNome.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Menu: ${widget.shoppingList.menuNome}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      'Semanas: ${widget.shoppingList.numeroSemanas}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Cabeçalho da lista de itens
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Itens da Lista (${_itens.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
            
            // Lista de itens
            _itens.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum item na lista',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Toque no botão + para incluir itens',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = _itens[index];
                        return Card(
                          margin: EdgeInsets.fromLTRB(
                            16,
                            index == 0 ? 0 : 4,
                            16,
                            index == _itens.length - 1 ? 16 : 4,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Checkbox(
                              value: item.comprado,
                              onChanged: (_) => _toggleItemComprado(index),
                            ),
                            title: Text(
                              item.nome,
                              style: TextStyle(
                                decoration: item.comprado
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: item.comprado
                                    ? Colors.grey
                                    : null,
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editarItem(index),
                                  tooltip: 'Editar item',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Theme.of(context).colorScheme.error,
                                  onPressed: () => _removerItem(index),
                                  tooltip: 'Remover item',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: _itens.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _showAdicionarItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemNomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do item *',
                  hintText: 'Ex: Arroz',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _itemQuantidadeController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade *',
                  hintText: 'Ex: 1kg',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _itemCategoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  hintText: 'Ex: Grãos',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _itemObservacoesController,
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
            onPressed: () {
              Navigator.of(context).pop();
              // Limpar campos
              _itemNomeController.clear();
              _itemQuantidadeController.clear();
              _itemCategoriaController.clear();
              _itemObservacoesController.clear();
            },
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              _adicionarItem();
              Navigator.of(context).pop();
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}