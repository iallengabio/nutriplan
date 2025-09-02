import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di.dart';
import '../../../../domain/models/shopping_list.dart';
import 'widgets/lista_info_basica_widget.dart';
import 'widgets/item_lista_card_widget.dart';
import 'widgets/adicionar_item_dialog.dart';

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
    super.dispose();
  }

  void _adicionarItem(ShoppingItem item) {
    setState(() {
      _itens.add(item);
    });
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
    
    showDialog(
      context: context,
      builder: (context) => AdicionarItemDialog(
         item: item,
         onSalvar: (itemEditado) {
           setState(() {
             _itens[index] = itemEditado;
           });
         },
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
                      ListaInfoBasicaWidget(
                        nomeController: _nomeController,
                        observacoesController: _observacoesController,
                      ),
                      const SizedBox(height: 16),
                      // Informações do menu associado
                      if (widget.shoppingList.menuNome.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            index == 0 ? 0 : 4,
                            16,
                            index == _itens.length - 1 ? 16 : 4,
                          ),
                          child: ItemListaCardWidget(
                            item: item,
                            index: index,
                            onToggleComprado: () => _toggleItemComprado(index),
                            onEditar: () => _editarItem(index),
                            onRemover: () => _removerItem(index),
                            isEditable: true,
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
      builder: (context) => AdicionarItemDialog(
        onSalvar: _adicionarItem,
      ),
    );
  }
}