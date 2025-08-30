import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'presentation/features/auth/login/login_page.dart';
import 'presentation/features/home/home_page.dart';
import 'core/services/intent_service.dart';
import 'presentation/features/home/listas/shopping_list_viewmodel.dart';
import 'domain/models/shopping_list.dart';
import 'di.dart';

// Provider para monitorar o estado de autenticação
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AppWrapper extends ConsumerStatefulWidget {
  const AppWrapper({super.key});

  @override
  ConsumerState<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> {
  @override
  void initState() {
    super.initState();
    // Inicializar o serviço de intents
    IntentService.initialize();
    
    // Escutar arquivos recebidos
    IntentService.fileReceived.listen((shoppingList) {
      _handleReceivedFile(shoppingList);
    });
  }

  void _handleReceivedFile(ShoppingList shoppingList) {
    // Verificar se o usuário está logado
    final authState = ref.read(authStateProvider);
    authState.whenData((user) {
      if (user != null) {
        // Usuário logado - importar a lista
        final viewModel = ref.read(shoppingListViewModelProvider.notifier);
        _importReceivedList(viewModel, shoppingList);
      } else {
        // Usuário não logado - mostrar mensagem
        _showLoginRequiredMessage();
      }
    });
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
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        // Se o usuário está logado, vai para a tela inicial
        if (user != null) {
          return const HomePage();
        }
        // Se não está logado, vai para a tela de login
        return const LoginPage();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Erro ao verificar autenticação',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Tentar novamente
                  ref.invalidate(authStateProvider);
                },
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}