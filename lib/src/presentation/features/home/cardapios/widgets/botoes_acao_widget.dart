import 'package:flutter/material.dart';
import '../menu_viewmodel.dart';

class BotoesAcaoWidget extends StatelessWidget {
  final MenuState menuState;
  final VoidCallback onGerarCardapio;
  final VoidCallback? onCancelar;
  final String? textoBotaoPrincipal;
  final String? textoBotaoSecundario;
  final bool showCancelButton;

  const BotoesAcaoWidget({
    super.key,
    required this.menuState,
    required this.onGerarCardapio,
    this.onCancelar,
    this.textoBotaoPrincipal,
    this.textoBotaoSecundario,
    this.showCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Exibir mensagem de erro se houver
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
        
        // Botão principal (Gerar Cardápio)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: menuState.isGeneratingMenu ? null : onGerarCardapio,
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
                : Text(
                    textoBotaoPrincipal ?? 'Gerar Cardápio',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
        
        // Botão secundário (Cancelar)
        if (showCancelButton) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onCancelar ?? () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                textoBotaoSecundario ?? 'Cancelar',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ],
    );
  }
}