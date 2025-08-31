import 'package:flutter/material.dart';
import '../../../../../domain/models/refeicao.dart';

class RefeicaoCardWidget extends StatelessWidget {
  final Refeicao refeicao;
  final bool isLoading;
  final VoidCallback? onEdit;
  final VoidCallback? onGenerateAlternative;
  final VoidCallback? onRemove;

  const RefeicaoCardWidget({
    super.key,
    required this.refeicao,
    this.isLoading = false,
    this.onEdit,
    this.onGenerateAlternative,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
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
                // Mostrar indicador de carregamento se a refeição estiver sendo processada
                if (isLoading)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Gerando...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'editar':
                          onEdit?.call();
                          break;
                        case 'alternativa':
                          onGenerateAlternative?.call();
                          break;
                        case 'remover':
                          onRemove?.call();
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
            ]
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
}