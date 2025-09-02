import 'package:flutter/material.dart';
import '../../../../../domain/models/menu.dart';
import '../../../../../domain/models/refeicao.dart';
import '../menu_viewmodel.dart';
import 'refeicao_card_widget.dart';
import 'seletor_dia_widget.dart';

class RefeicoesSectionWidget extends StatelessWidget {
  final Menu menu;
  final DiaSemana diaSelecionado;
  final ValueChanged<DiaSemana> onDiaChanged;
  final ScrollController scrollController;
  final Map<String, bool> refeicaoCarregando;
  final VoidCallback onAdicionarRefeicao;
  final Function(int) onEditarRefeicao;
  final Function(TipoRefeicao, MenuViewModel, int) onGerarAlternativa;
  final Function(int) onRemoverRefeicao;
  final MenuViewModel menuViewModel;

  const RefeicoesSectionWidget({
    super.key,
    required this.menu,
    required this.diaSelecionado,
    required this.onDiaChanged,
    required this.scrollController,
    required this.refeicaoCarregando,
    required this.onAdicionarRefeicao,
    required this.onEditarRefeicao,
    required this.onGerarAlternativa,
    required this.onRemoverRefeicao,
    required this.menuViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final refeicoesDoDia = menu.refeicoesDoDia(diaSelecionado);
    
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
                  onPressed: onAdicionarRefeicao,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SeletorDiaWidget(
              diaSelecionado: diaSelecionado,
              onDiaChanged: onDiaChanged,
              scrollController: scrollController,
            ),
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
                  final chaveCarregamento = '${diaSelecionado.name}_$index';
                  return RefeicaoCardWidget(
                    refeicao: refeicao,
                    isLoading: refeicaoCarregando[chaveCarregamento] ?? false,
                    onEdit: () => onEditarRefeicao(index),
                    onGenerateAlternative: () => onGerarAlternativa(refeicao.tipo, menuViewModel, index),
                    onRemove: () => onRemoverRefeicao(index),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}