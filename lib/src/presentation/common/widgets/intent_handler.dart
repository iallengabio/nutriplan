import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/intent_service.dart';
import '../../../domain/models/shopping_list.dart';
import '../../features/home/listas/shopping_list_viewmodel.dart';
import '../../../di.dart';

/// Widget responsável pelo processamento de intents de arquivos
/// Segue o princípio da responsabilidade única (SRP)
class IntentHandler extends ConsumerStatefulWidget {
  final Widget child;
  
  const IntentHandler({super.key, required this.child});

  @override
  ConsumerState<IntentHandler> createState() => _IntentHandlerState();
}

class _IntentHandlerState extends ConsumerState<IntentHandler> {
  @override
  void initState() {
    super.initState();
    _initializeIntentService();
  }

  void _initializeIntentService() {
    // Inicializar o serviço de intents
    IntentService.initialize();
    
    // Escutar arquivos recebidos
    IntentService.fileReceived.listen((shoppingList) {
      _handleReceivedFile(shoppingList);
    });
  }

  void _handleReceivedFile(ShoppingList shoppingList) {
    // Verificar se o usuário está logado
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    if (isAuthenticated) {
      // Usuário logado - importar a lista
      final viewModel = ref.read(shoppingListViewModelProvider.notifier);
      _importReceivedList(viewModel, shoppingList);
    } else {
      // Usuário não logado - mostrar mensagem
      _showLoginRequiredMessage();
    }
  }

  Future<void> _importReceivedList(ShoppingListViewModel viewModel, ShoppingList shoppingList) async {
    try {
      // Usar o repositório diretamente para salvar a lista
      final repository = ref.read(shoppingListRepositoryProvider);
      final result = await repository.salvarNovaListaCompras(shoppingList);
      
      result.fold(
        (listaSalva) {
          // Recarregar as listas
          viewModel.carregarListasDeCompras();
          
          // Mostrar mensagem de sucesso
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lista "${listaSalva.nome}" importada com sucesso!'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        },
        (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao importar lista: ${error.toString()}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao importar lista: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showLoginRequiredMessage() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faça login para importar listas de compras'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}