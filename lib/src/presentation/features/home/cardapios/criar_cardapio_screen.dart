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
import '../../profile/family_profile_viewmodel.dart';

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
  bool _usarPerfilSalvo = true;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarPerfilFamiliar();
    });
  }
  
  void _carregarPerfilFamiliar() async {
    final familyProfileViewModel = ref.read(familyProfileViewModelProvider.notifier);
    await familyProfileViewModel.carregarPerfil();
    
    final state = ref.read(familyProfileViewModelProvider);
    if (state.perfil != null && mounted) {
      setState(() {
        _numeroAdultos = state.perfil!.numeroAdultos;
        _numeroCriancas = state.perfil!.numeroCriancas;
        _restricoesAlimentares = Set.from(state.perfil!.restricoesAlimentares);
        if (state.perfil!.observacoesAdicionais != null) {
          _observacoesController.text = state.perfil!.observacoesAdicionais!;
        }
      });
    }
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
              _buildPerfilSalvoSwitch(),
              const SizedBox(height: 16),
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

  Widget _buildPerfilSalvoSwitch() {
    final familyProfileState = ref.watch(familyProfileViewModelProvider);
    final temPerfilSalvo = familyProfileState.perfil != null;
    
    if (!temPerfilSalvo) {
      return const SizedBox.shrink();
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.family_restroom,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Usar Perfil Familiar Salvo',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Use as configurações do seu perfil familiar',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Switch(
              value: _usarPerfilSalvo,
              onChanged: (value) {
                setState(() {
                  _usarPerfilSalvo = value;
                  if (value) {
                    _carregarPerfilFamiliar();
                  }
                });
              },
            ),
          ],
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

    // Obter o perfil salvo ou criar um novo
    final familyProfileState = ref.read(familyProfileViewModelProvider);
    final familyProfileViewModel = ref.read(familyProfileViewModelProvider.notifier);
    
    PerfilFamiliar perfil;
    
    if (_usarPerfilSalvo && familyProfileState.perfil != null) {
      // Usar perfil salvo, mas atualizar com valores da tela se diferentes
      perfil = familyProfileState.perfil!;
      
      // Verificar se houve mudanças e atualizar o perfil salvo
      bool houveMudancas = false;
      
      if (perfil.numeroAdultos != _numeroAdultos) {
        familyProfileViewModel.atualizarNumeroAdultos(_numeroAdultos);
        houveMudancas = true;
      }
      
      if (perfil.numeroCriancas != _numeroCriancas) {
        familyProfileViewModel.atualizarNumeroCriancas(_numeroCriancas);
        houveMudancas = true;
      }
      
      if (!perfil.restricoesAlimentares.containsAll(_restricoesAlimentares) ||
          !_restricoesAlimentares.containsAll(perfil.restricoesAlimentares)) {
        // Atualizar restrições
        for (final restricao in _restricoesAlimentares) {
          if (!perfil.restricoesAlimentares.contains(restricao)) {
            familyProfileViewModel.adicionarRestricao(restricao);
            houveMudancas = true;
          }
        }
        for (final restricao in perfil.restricoesAlimentares) {
          if (!_restricoesAlimentares.contains(restricao)) {
            familyProfileViewModel.removerRestricao(restricao);
            houveMudancas = true;
          }
        }
      }
      
      final observacoesAtuais = _observacoesController.text.trim().isEmpty 
          ? null 
          : _observacoesController.text.trim();
      if (perfil.observacoesAdicionais != observacoesAtuais) {
        familyProfileViewModel.atualizarObservacoes(observacoesAtuais ?? '');
        houveMudancas = true;
      }
      
      // Salvar mudanças se houver
      if (houveMudancas) {
        await familyProfileViewModel.salvarPerfil();
      }
      
      // Usar o perfil atualizado
      final updatedState = ref.read(familyProfileViewModelProvider);
      perfil = updatedState.perfil ?? perfil;
    } else {
      // Criar perfil temporário
      perfil = PerfilFamiliar(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        numeroAdultos: _numeroAdultos,
        numeroCriancas: _numeroCriancas,
        restricoesAlimentares: _restricoesAlimentares,
        observacoesAdicionais: _observacoesController.text.trim().isEmpty 
            ? null 
            : _observacoesController.text.trim(),
        dataUltimaAtualizacao: DateTime.now(),
      );
    }

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