import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di.dart';
import '../../../../domain/models/menu.dart';
import '../../../../domain/models/shopping_list.dart';
import '../../home/cardapios/menu_viewmodel.dart';
import '../../home/listas/shopping_list_viewmodel.dart';

class CreateShoppingListFromMenuPage extends ConsumerStatefulWidget {
  const CreateShoppingListFromMenuPage({super.key});

  @override
  ConsumerState<CreateShoppingListFromMenuPage> createState() => _CreateShoppingListFromMenuPageState();
}

class _CreateShoppingListFromMenuPageState extends ConsumerState<CreateShoppingListFromMenuPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _observacoesController = TextEditingController();
  Menu? _menuSelecionado;
  int _numeroSemanas = 1;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    // Carrega os cardápios disponíveis
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuViewModelProvider.notifier).carregarMenus();
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuViewModelProvider);
    final shoppingListState = ref.watch(shoppingListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Lista de Compras'),
        actions: [
          TextButton(
            onPressed: (_isGenerating || _menuSelecionado == null) 
                ? null 
                : () => _gerarListaDeCompras(),
            child: _isGenerating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Gerar Lista'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardapioSelectionSection(menuState),
              const SizedBox(height: 24),
              _buildConfigurationSection(),
              const SizedBox(height: 24),
              _buildBasicInfoSection(),
              if (shoppingListState.errorMessage != null) ...[
                const SizedBox(height: 16),
                _buildErrorSection(shoppingListState.errorMessage!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardapioSelectionSection(MenuState menuState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecionar Cardápio',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Escolha um cardápio para gerar a lista de compras:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (menuState.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (menuState.menus.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nenhum cardápio disponível',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Crie um cardápio primeiro para gerar listas de compras',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _menuSelecionado == null 
                        ? Theme.of(context).colorScheme.error 
                        : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: menuState.menus.map((menu) {
                    final isSelected = _menuSelecionado?.id == menu.id;
                    final totalRefeicoes = menu.refeicoesPorDia.values
                        .expand((refeicoes) => refeicoes)
                        .length;
                    
                    return RadioListTile<Menu>(
                      value: menu,
                      groupValue: _menuSelecionado,
                      onChanged: (Menu? value) {
                        setState(() {
                          _menuSelecionado = value;
                        });
                      },
                      title: Text(
                        menu.nome,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Criado em ${_formatarData(menu.dataCriacao)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '$totalRefeicoes refeições',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      secondary: menu.isFavorito
                          ? Icon(
                              Icons.favorite,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (_menuSelecionado == null && menuState.menus.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Selecione um cardápio',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configurações',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Número de Semanas',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Para quantas semanas você quer comprar?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _numeroSemanas > 1
                            ? () => setState(() => _numeroSemanas--)
                            : null,
                        icon: const Icon(Icons.remove),
                        iconSize: 20,
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 40),
                        child: Text(
                          '$_numeroSemanas',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _numeroSemanas < 4
                            ? () => setState(() => _numeroSemanas++)
                            : null,
                        icon: const Icon(Icons.add),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'As quantidades dos ingredientes serão calculadas para $_numeroSemanas semana${_numeroSemanas > 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
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
              'Informações da Lista',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome da Lista (opcional)',
                hintText: _menuSelecionado != null 
                    ? 'Lista de Compras - ${_menuSelecionado!.nome}'
                    : 'Ex: Compras da semana',
                border: const OutlineInputBorder(),
                helperText: 'Se não informado, será gerado automaticamente',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observacoesController,
              decoration: const InputDecoration(
                labelText: 'Observações (opcional)',
                hintText: 'Ex: Preferir produtos orgânicos, evitar marca X',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection(String errorMessage) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  Future<void> _gerarListaDeCompras() async {
    if (!_formKey.currentState!.validate() || _menuSelecionado == null) {
      if (_menuSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione um cardápio para continuar'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final shoppingListViewModel = ref.read(shoppingListViewModelProvider.notifier);
      
      // Gera a lista de compras baseada no cardápio selecionado
      await shoppingListViewModel.gerarListaDeCompras(
        menu: _menuSelecionado!,
        numeroSemanas: _numeroSemanas,
        nome: _nomeController.text.trim().isEmpty 
            ? null 
            : _nomeController.text.trim(),
      );

      // Verifica se houve erro
      final currentState = ref.read(shoppingListViewModelProvider);
      if (currentState.errorMessage == null && mounted) {
        // Sucesso - volta para a tela anterior
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lista de compras gerada com sucesso!',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro inesperado: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }
}