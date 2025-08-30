import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di.dart';
import 'shopping_list_viewmodel.dart';
import '../../../../domain/models/shopping_list.dart';

class CreateShoppingListPage extends ConsumerStatefulWidget {
  const CreateShoppingListPage({super.key});

  @override
  ConsumerState<CreateShoppingListPage> createState() => _CreateShoppingListPageState();
}

class _CreateShoppingListPageState extends ConsumerState<CreateShoppingListPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _observacoesController = TextEditingController();
  final List<ShoppingItem> _itens = [];
  final _itemNomeController = TextEditingController();
  final _itemQuantidadeController = TextEditingController();
  final _itemCategoriaController = TextEditingController();
  final _itemObservacoesController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final shoppingListState = ref.watch(shoppingListViewModelProvider);
    final shoppingListViewModel = ref.read(shoppingListViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Lista de Compras'),
        actions: [
          TextButton(
            onPressed: shoppingListState.isSaving ? null : () => _salvarLista(shoppingListViewModel),
            child: shoppingListState.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Salvar'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(),
                    const SizedBox(height: 24),
                    _buildItensSection(),
                  ],
                ),
              ),
            ),
            _buildAddItemSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações Básicas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome da Lista *',
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
          ],
        ),
      ),
    );
  }

  Widget _buildItensSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Itens da Lista',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_itens.length} itens',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_itens.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nenhum item adicionado',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Use o formulário abaixo para adicionar itens',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _itens.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = _itens[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      child: Icon(
                        Icons.shopping_basket,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    title: Text(item.nome),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantidade: ${item.quantidade}'),
                        if (item.categoria?.isNotEmpty == true)
                          Text('Categoria: ${item.categoria}'),
                        if (item.observacoes?.isNotEmpty == true)
                          Text('Obs: ${item.observacoes}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removerItem(index),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddItemSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: ExpansionTile(
        title: const Text('Adicionar Item'),
        leading: const Icon(Icons.add),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _itemNomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Item *',
                          hintText: 'Ex: Arroz',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _itemQuantidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Quantidade *',
                          hintText: 'Ex: 1kg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _itemCategoriaController,
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                          hintText: 'Ex: Grãos',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _itemObservacoesController,
                        decoration: const InputDecoration(
                          labelText: 'Observações',
                          hintText: 'Ex: Marca específica',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _adicionarItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Item'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _adicionarItem() {
    final nome = _itemNomeController.text.trim();
    final quantidade = _itemQuantidadeController.text.trim();
    final categoria = _itemCategoriaController.text.trim();
    final observacoes = _itemObservacoesController.text.trim();

    if (nome.isEmpty || quantidade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome e quantidade são obrigatórios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final novoItem = ShoppingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      quantidade: quantidade,
      categoria: categoria.isEmpty ? null : categoria,
      observacoes: observacoes.isEmpty ? null : observacoes,
    );

    setState(() {
      _itens.add(novoItem);
      _itemNomeController.clear();
      _itemQuantidadeController.clear();
      _itemCategoriaController.clear();
      _itemObservacoesController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item "$nome" adicionado!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _removerItem(int index) {
    final item = _itens[index];
    setState(() {
      _itens.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item "${item.nome}" removido!'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _itens.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  void _salvarLista(ShoppingListViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_itens.isEmpty) {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lista Vazia'),
          content: const Text('Deseja salvar uma lista sem itens?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Salvar'),
            ),
          ],
        ),
      );

      if (confirmar != true) return;
    }

    final novaLista = ShoppingList(
      id: '', // Será gerado pelo Firebase
      nome: _nomeController.text.trim(),
      dataCriacao: DateTime.now(),
      menuId: '', // Lista criada manualmente
      menuNome: 'Lista manual',
      numeroSemanas: 1,
      itens: _itens,
      observacoes: _observacoesController.text.trim().isEmpty 
          ? null 
          : _observacoesController.text.trim(),
      dataUltimaEdicao: DateTime.now(),
    );

    // Salvar a lista usando o método correto do repository
    final result = await ref.read(shoppingListRepositoryProvider).salvarNovaListaCompras(novaLista);
    
    result.fold(
      (listaSalva) {
        // Sucesso - atualizar o estado local e voltar para a tela anterior
        viewModel.carregarListasDeCompras();
        
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lista "${novaLista.nome}" criada com sucesso!'),
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
}