import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/menu.dart';
import '../../../../domain/models/refeicao.dart';
import '../../../../di.dart';
import 'menu_viewmodel.dart';

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
                  _buildInfoBasica(),
                  const SizedBox(height: 24),
                  _buildRefeicoes(menuViewModel),
                  const SizedBox(height: 24),
                  _buildObservacoes(),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoBasica() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações Básicas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Cardápio',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _menuEditado = _menuEditado.copyWith(nome: value);
                });
              },
            ),
            const SizedBox(height: 16),
            _buildInfoPerfil(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPerfil() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações do Cardápio',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text('Criado em: ${_formatDate(_menuEditado.dataCriacao)}'),
          ],
        ),
        if (_menuEditado.dataUltimaEdicao != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.edit, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text('Última edição: ${_formatDate(_menuEditado.dataUltimaEdicao!)}'),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.restaurant, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text('Total de refeições: ${_menuEditado.totalRefeicoes}'),
          ],
        ),
      ],
    );
  }

  Widget _buildRefeicoes(MenuViewModel menuViewModel) {
    final refeicoesDoDia = _menuEditado.refeicoesDoDia(_diaSelecionado);
    
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
                  'Refeições',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _adicionarRefeicao(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSeletorDia(),
            const SizedBox(height: 16),
            if (refeicoesDoDia.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Nenhuma refeição para este dia.\nToque no botão + para adicionar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: refeicoesDoDia.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final refeicao = refeicoesDoDia[index];
                  return _buildRefeicaoCard(refeicao, index, menuViewModel);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefeicaoCard(Refeicao refeicao, int index, MenuViewModel menuViewModel) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTipoRefeicaoColor(refeicao.tipo),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    refeicao.tipo.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'editar':
                        _editarRefeicao(index);
                        break;
                      case 'alternativa':
                        _gerarAlternativa(refeicao.tipo, menuViewModel);
                        break;
                      case 'remover':
                        _removerRefeicao(index);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'alternativa',
                      child: Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 8),
                          Text('Gerar Alternativa'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'remover',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Remover', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              refeicao.nome,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              refeicao.descricao,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${refeicao.tempoPreparoMinutos} min',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${refeicao.porcoes} porções',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            if (refeicao.ingredientes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Ingredientes: ${refeicao.ingredientes.take(3).join(', ')}${refeicao.ingredientes.length > 3 ? '...' : ''}',
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildObservacoes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Observações',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observacoesController,
              decoration: const InputDecoration(
                labelText: 'Observações adicionais',
                border: OutlineInputBorder(),
                hintText: 'Digite observações sobre o cardápio...',
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  _menuEditado = _menuEditado.copyWith(observacoes: value.isEmpty ? null : value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getTipoRefeicaoColor(TipoRefeicao tipo) {
    switch (tipo) {
      case TipoRefeicao.cafeManha:
        return Colors.orange;
      case TipoRefeicao.lanche:
        return Colors.green;
      case TipoRefeicao.almoco:
        return Colors.blue;
      case TipoRefeicao.jantar:
        return Colors.purple;
      case TipoRefeicao.ceia:
        return Colors.indigo;
    }
  }

  Widget _buildSeletorDia() {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: DiaSemana.values.map((dia) {
          final isSelected = dia == _diaSelecionado;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(dia.displayName.split('-').first),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _diaSelecionado = dia;
                });
                _centralizarDiaSelecionado();
              },
            ),
          );
        }).toList(),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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

  void _gerarAlternativa(TipoRefeicao tipo, MenuViewModel menuViewModel) async {
    // TODO: Implementar geração de alternativa
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de gerar alternativa será implementada'),
      ),
    );
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