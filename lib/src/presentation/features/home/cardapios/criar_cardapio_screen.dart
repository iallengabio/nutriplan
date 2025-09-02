import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/perfil_familiar.dart';
import '../../../../domain/models/refeicao.dart';
import 'editar_cardapio_screen.dart';
import 'menu_viewmodel.dart';
import 'widgets/perfil_familiar_widget.dart';
import 'widgets/tipos_refeicao_widget.dart';
import 'widgets/observacoes_widget.dart';
import 'widgets/nome_cardapio_widget.dart';
import 'widgets/botoes_acao_widget.dart';
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
  String? _erroTiposRefeicao;
  
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
              NomeCardapioWidget(
                controller: _nomeController,
                title: 'Nome do Cardápio',
                hintText: 'Ex: Cardápio da Semana (opcional)',
              ),
              const SizedBox(height: 24),
              PerfilFamiliarWidget(
                  numeroAdultos: _numeroAdultos,
                  numeroCriancas: _numeroCriancas,
                  restricoesAlimentares: _restricoesAlimentares,
                  onAdultosChanged: (valor) {
                    setState(() {
                      _numeroAdultos = valor;
                    });
                  },
                  onCriancasChanged: (valor) {
                    setState(() {
                      _numeroCriancas = valor;
                    });
                  },
                  onRestricaoChanged: (restricoes) {
                    setState(() {
                      _restricoesAlimentares = restricoes;
                    });
                  },
                ),
              const SizedBox(height: 24),
              TiposRefeicaoWidget(
                  tiposSelecionados: _tiposRefeicao,
                  onChanged: (tipos) {
                    setState(() {
                      _tiposRefeicao = tipos;
                      _erroTiposRefeicao = null;
                    });
                  },
                  showError: _erroTiposRefeicao != null,
                ),
              const SizedBox(height: 24),
              ObservacoesWidget(
                  controller: _observacoesController,
                  title: 'Observações',
                  hintText: 'Adicione observações especiais para o cardápio...',
                ),
              const SizedBox(height: 32),
              BotoesAcaoWidget(
                menuState: menuState,
                onGerarCardapio: () => _gerarCardapio(menuViewModel),
              ),
            ],
          ),
        ),
      ),
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
      numberOfPeople: _numeroAdultos + _numeroCriancas,
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


}