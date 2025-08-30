import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/perfil_familiar.dart';
import '../../../../domain/models/refeicao.dart';
import 'menu_viewmodel.dart';
import 'editar_cardapio_screen.dart';
import '../../../../di.dart';

class CriarCardapioScreen extends ConsumerStatefulWidget {
  const CriarCardapioScreen({super.key});

  @override
  ConsumerState<CriarCardapioScreen> createState() => _CriarCardapioScreenState();
}

class _CriarCardapioScreenState extends ConsumerState<CriarCardapioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _observacoesController = TextEditingController();
  
  int _numeroAdultos = 2;
  int _numeroCriancas = 0;
  Set<RestricaoAlimentar> _restricoesAlimentares = {};
  Set<TipoRefeicao> _tiposRefeicao = {TipoRefeicao.almoco, TipoRefeicao.jantar};
  
  @override
  void dispose() {
    _nomeController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuViewModelProvider);
    final menuViewModel = ref.read(menuViewModelProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Cardápio'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNomeSection(),
              const SizedBox(height: 24),
              _buildPerfilFamiliarSection(),
              const SizedBox(height: 24),
              _buildTiposRefeicaoSection(),
              const SizedBox(height: 24),
              _buildObservacoesSection(),
              const SizedBox(height: 32),
              _buildBotoesAcao(context, menuState, menuViewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nome do Cardápio',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nomeController,
          decoration: const InputDecoration(
            hintText: 'Ex: Cardápio da Semana (opcional)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPerfilFamiliarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perfil Familiar',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Número de adultos
        Row(
          children: [
            Expanded(
              child: Text(
                'Número de adultos:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _numeroAdultos > 1 ? () {
                    setState(() {
                      _numeroAdultos--;
                    });
                  } : null,
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _numeroAdultos.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: _numeroAdultos < 10 ? () {
                    setState(() {
                      _numeroAdultos++;
                    });
                  } : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Número de crianças
        Row(
          children: [
            Expanded(
              child: Text(
                'Número de crianças:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _numeroCriancas > 0 ? () {
                    setState(() {
                      _numeroCriancas--;
                    });
                  } : null,
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _numeroCriancas.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: _numeroCriancas < 10 ? () {
                    setState(() {
                      _numeroCriancas++;
                    });
                  } : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Restrições alimentares
        Text(
          'Restrições Alimentares:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RestricaoAlimentar.values.map((restricao) {
            final isSelected = _restricoesAlimentares.contains(restricao);
            return FilterChip(
              label: Text(_getRestricaoLabel(restricao)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _restricoesAlimentares.add(restricao);
                  } else {
                    _restricoesAlimentares.remove(restricao);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTiposRefeicaoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipos de Refeição',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecione quais refeições deseja incluir no cardápio:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TipoRefeicao.values.map((tipo) {
            final isSelected = _tiposRefeicao.contains(tipo);
            return FilterChip(
              label: Text(_getTipoRefeicaoLabel(tipo)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _tiposRefeicao.add(tipo);
                  } else {
                    _tiposRefeicao.remove(tipo);
                  }
                });
              },
            );
          }).toList(),
        ),
        if (_tiposRefeicao.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Selecione pelo menos um tipo de refeição',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildObservacoesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Observações Adicionais',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _observacoesController,
          decoration: const InputDecoration(
            hintText: 'Ex: Preferências, ingredientes específicos, etc.',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildBotoesAcao(BuildContext context, MenuState menuState, MenuViewModel menuViewModel) {
    return Column(
      children: [
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
              ],
            ),
          ),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: menuState.isGeneratingMenu ? null : () => _gerarCardapio(menuViewModel),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: menuState.isGeneratingMenu
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Gerando cardápio...'),
                    ],
                  )
                : const Text(
                    'Gerar Cardápio',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _gerarCardapio(MenuViewModel menuViewModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_tiposRefeicao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos um tipo de refeição'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final perfil = PerfilFamiliar(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      numeroAdultos: _numeroAdultos,
      numeroCriancas: _numeroCriancas,
      restricoesAlimentares: _restricoesAlimentares,
      observacoesAdicionais: _observacoesController.text.trim().isEmpty 
          ? null 
          : _observacoesController.text.trim(),
      dataUltimaAtualizacao: DateTime.now(),
    );

    await menuViewModel.gerarMenu(
      perfil: perfil,
      tiposRefeicao: _tiposRefeicao,
      nome: _nomeController.text.trim().isEmpty 
          ? null 
          : _nomeController.text.trim(),
      observacoesAdicionais: _observacoesController.text.trim().isEmpty 
          ? null 
          : _observacoesController.text.trim(),
    );

    // Se a geração foi bem-sucedida, navegar para a tela de edição
    final currentState = ref.read(menuViewModelProvider);
    if (mounted && currentState.menuSelecionado != null && currentState.errorMessage == null) {
      // Navegar para tela de edição do cardápio gerado
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EditarCardapioScreen(
            menu: currentState.menuSelecionado!,
          ),
        ),
      );
    }
  }

  String _getRestricaoLabel(RestricaoAlimentar restricao) {
    return restricao.displayName;
  }

  String _getTipoRefeicaoLabel(TipoRefeicao tipo) {
    return tipo.displayName;
  }
}