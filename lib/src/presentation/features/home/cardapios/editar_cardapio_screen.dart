import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/menu.dart';
import '../../../../domain/models/perfil_familiar.dart';
import '../../../../domain/models/refeicao.dart';
import '../../../../di.dart';
import 'menu_viewmodel.dart';
import 'widgets/info_basica_widget.dart';
import 'widgets/info_perfil_widget.dart';
import 'widgets/observacoes_widget.dart';
import 'widgets/refeicoes_section_widget.dart';

class EditarCardapioScreen extends ConsumerStatefulWidget {
  final Menu menu;

  const EditarCardapioScreen({
    super.key,
    required this.menu,
  });

  @override
  ConsumerState<EditarCardapioScreen> createState() => _EditarCardapioScreenState();
}

class _EditarCardapioScreenState extends ConsumerState<EditarCardapioScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _observacoesController;
  late Menu _menuEditado;
  DiaSemana _diaSelecionado = DiaSemana.segunda;
  late ScrollController _scrollController;
  
  // Mapa para controlar o estado de carregamento de cada refeição
  final Map<String, bool> _refeicaoCarregando = {};

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.menu.nome);
    _observacoesController = TextEditingController(text: widget.menu.observacoes ?? '');
    _menuEditado = widget.menu;
    _diaSelecionado = _getDiaAtualDoSistema();
    _scrollController = ScrollController();
    
    // Aguarda o próximo frame para centralizar o dia selecionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centralizarDiaSelecionado();
    });
  }

  /// Obtém o dia atual do sistema e mapeia para o enum DiaSemana
  DiaSemana _getDiaAtualDoSistema() {
    final agora = DateTime.now();
    switch (agora.weekday) {
      case DateTime.monday:
        return DiaSemana.segunda;
      case DateTime.tuesday:
        return DiaSemana.terca;
      case DateTime.wednesday:
        return DiaSemana.quarta;
      case DateTime.thursday:
        return DiaSemana.quinta;
      case DateTime.friday:
        return DiaSemana.sexta;
      case DateTime.saturday:
        return DiaSemana.sabado;
      case DateTime.sunday:
        return DiaSemana.domingo;
      default:
        return DiaSemana.segunda; // fallback
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _observacoesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuViewModelProvider);
    final menuViewModel = ref.read(menuViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cardápio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: menuState.isSaving ? null : () => _salvarCardapio(menuViewModel),
          ),
        ],
      ),
      body: menuState.isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoBasicaWidget(
                    nomeController: _nomeController,
                    menu: _menuEditado,
                    onNomeChanged: (value) {
                      setState(() {
                        _menuEditado = _menuEditado.copyWith(nome: value);
                      });
                    },
                    infoPerfilWidget: InfoPerfilWidget(menu: _menuEditado),
                  ),
                  const SizedBox(height: 24),
                  RefeicoesSectionWidget(
                    menu: _menuEditado,
                    diaSelecionado: _diaSelecionado,
                    onDiaChanged: (dia) {
                      setState(() {
                        _diaSelecionado = dia;
                      });
                      _centralizarDiaSelecionado();
                    },
                    scrollController: _scrollController,
                    refeicaoCarregando: _refeicaoCarregando,
                    onAdicionarRefeicao: _adicionarRefeicao,
                    onEditarRefeicao: _editarRefeicao,
                    onGerarAlternativa: _gerarAlternativa,
                    onRemoverRefeicao: _removerRefeicao,
                    menuViewModel: menuViewModel,
                  ),
                  const SizedBox(height: 24),
                  ObservacoesWidget(
                  controller: _observacoesController,
                  title: 'Observações do Cardápio',
                  hintText: 'Adicione observações especiais para este cardápio...',
                ),
                ],
              ),
            ),
    );
  }










  /// Centraliza o dia selecionado no scroll horizontal
  void _centralizarDiaSelecionado() {
    if (!_scrollController.hasClients) return;
    
    final indiceDiaSelecionado = DiaSemana.values.indexOf(_diaSelecionado);
    const larguraChip = 80.0; // Largura aproximada de cada chip + padding
    const larguraTela = 350.0; // Largura aproximada da tela visível
    
    // Calcula a posição do chip selecionado
    final posicaoChip = indiceDiaSelecionado * larguraChip;
    
    // Calcula a posição de scroll para centralizar o chip
    final posicaoCentralizada = posicaoChip - (larguraTela / 2) + (larguraChip / 2);
    
    // Limita a posição para não ultrapassar os extremos
    final maxScroll = _scrollController.position.maxScrollExtent;
    final posicaoFinal = posicaoCentralizada.clamp(0.0, maxScroll);
    
    _scrollController.animateTo(
      posicaoFinal,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }



  void _adicionarRefeicao() {
    // TODO: Implementar diálogo para adicionar nova refeição
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de adicionar refeição será implementada'),
      ),
    );
  }

  void _editarRefeicao(int index) {
    final refeicoesDoDia = _menuEditado.refeicoesDoDia(_diaSelecionado);
    if (index >= refeicoesDoDia.length) return;
    
    final refeicao = refeicoesDoDia[index];
    
    // TODO: Implementar diálogo para editar refeição
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar refeição: ${refeicao.nome}'),
      ),
    );
  }

  void _gerarAlternativa(TipoRefeicao tipo, MenuViewModel menuViewModel, int refeicaoIndex) async {
    final refeicoesDoDia = _menuEditado.refeicoesDoDia(_diaSelecionado);
    if (refeicaoIndex >= refeicoesDoDia.length) return;
    
    final refeicaoOriginal = refeicoesDoDia[refeicaoIndex];
    final refeicaoId = refeicaoOriginal.id;
    
    // Marcar refeição como carregando
    setState(() {
      _refeicaoCarregando[refeicaoId] = true;
    });
    
    try {
      // Criar um perfil familiar baseado no menu atual
      final perfil = PerfilFamiliar(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        numeroAdultos: 2, // Valor padrão, pode ser configurado
        numeroCriancas: 0, // Valor padrão, pode ser configurado
        restricoesAlimentares: <RestricaoAlimentar>{}, // Pode ser configurado baseado no menu
        observacoesAdicionais: _menuEditado.observacoes,
        dataUltimaAtualizacao: DateTime.now(),
      );

      await menuViewModel.gerarRefeicaoAlternativa(
        perfil: perfil,
        tipo: tipo,
        observacoesAdicionais: 'Gerar alternativa para ${tipo.displayName}',
      );

      // Verificar se houve erro
      final currentState = ref.read(menuViewModelProvider);
      if (currentState.errorMessage != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(currentState.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (currentState.refeicaoAlternativaGerada != null) {
        // Substituir a refeição no menu local
        final novaRefeicao = currentState.refeicaoAlternativaGerada!;
        
        setState(() {
          _menuEditado = _menuEditado.substituirRefeicao(
            _diaSelecionado,
            refeicaoOriginal.id,
            novaRefeicao,
          );
        });
        
        // Limpar a refeição alternativa do estado
        menuViewModel.limparRefeicaoAlternativa();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Refeição "${refeicaoOriginal.nome}" foi substituída por "${novaRefeicao.nome}"!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } finally {
      // Sempre limpar o estado de carregamento
      if (mounted) {
        setState(() {
          _refeicaoCarregando[refeicaoId] = false;
        });
      }
    }
  }

  void _removerRefeicao(int index) {
    final refeicoesDoDia = _menuEditado.refeicoesDoDia(_diaSelecionado);
    if (index >= refeicoesDoDia.length) return;
    
    final refeicao = refeicoesDoDia[index];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Refeição'),
        content: Text(
          'Tem certeza que deseja remover "${refeicao.nome}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _menuEditado = _menuEditado.removerRefeicao(_diaSelecionado, refeicao.id);
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  void _salvarCardapio(MenuViewModel menuViewModel) async {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome do cardápio é obrigatório'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final menuFinal = _menuEditado.copyWith(
      nome: _nomeController.text.trim(),
      observacoes: _observacoesController.text.trim().isEmpty 
          ? null 
          : _observacoesController.text.trim(),
    );

    try {
      await menuViewModel.atualizarMenu(menuFinal);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cardápio salvo com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Retorna true indicando que foi salvo
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar cardápio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}