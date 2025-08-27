import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_viewmodel.dart';
import 'cardapios/cardapios_tab.dart';
import 'listas/listas_tab.dart';
import 'perfil/perfil_tab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFabMenuOpen = false;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  late Animation<double> _fabRotationAnimation;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabRotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  Widget _buildFabWithMenu() {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Menu items
        AnimatedBuilder(
          animation: _fabAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _fabAnimation.value,
              child: Opacity(
                opacity: _fabAnimation.value,
                child: Visibility(
                  visible: _fabAnimation.value > 0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: FloatingActionButton.extended(
                      heroTag: "fab_lista",
                      onPressed: () {
                        _closeFabMenu();
                        _showNovaListaDialog(homeViewModel);
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Lista'),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      foregroundColor: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _fabAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _fabAnimation.value,
              child: Opacity(
                opacity: _fabAnimation.value,
                child: Visibility(
                  visible: _fabAnimation.value > 0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: FloatingActionButton.extended(
                      heroTag: "fab_cardapio",
                      onPressed: () {
                        _closeFabMenu();
                        _showNovoCardapioDialog(homeViewModel);
                      },
                      icon: const Icon(Icons.restaurant_menu),
                      label: const Text('Cardápio'),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // Main FAB
        AnimatedBuilder(
          animation: _fabRotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _fabRotationAnimation.value * 2 * 3.14159,
              child: FloatingActionButton(
                heroTag: "main_fab",
                onPressed: _toggleFabMenu,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Icon(
                  _isFabMenuOpen ? Icons.close : Icons.add,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _toggleFabMenu() {
    setState(() {
      _isFabMenuOpen = !_isFabMenuOpen;
    });
    
    if (_isFabMenuOpen) {
      _fabAnimationController.forward();
      _startAutoCloseTimer();
    } else {
      _fabAnimationController.reverse();
      _cancelAutoCloseTimer();
    }
  }

  void _closeFabMenu() {
    if (_isFabMenuOpen) {
      setState(() {
        _isFabMenuOpen = false;
      });
      _fabAnimationController.reverse();
      _cancelAutoCloseTimer();
    }
  }

  void _startAutoCloseTimer() {
    _cancelAutoCloseTimer();
    _autoCloseTimer = Timer(const Duration(seconds: 4), () {
      _closeFabMenu();
    });
  }

  void _cancelAutoCloseTimer() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;
  }



  @override
  Widget build(BuildContext context) {
    ref.watch(homeViewModelProvider);
    ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriPlan'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navegar para tela de configurações
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _closeFabMenu,
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            CardapiosTab(),
            ListasTab(),
            PerfilTab(),
          ],
        ),
      ),
      floatingActionButton: _buildFabWithMenu(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Cardápios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Listas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }











  void _showNovoCardapioDialog(HomeViewModel homeViewModel) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Cardápio'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nome do cardápio',
            hintText: 'Ex: Cardápio da Semana',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                homeViewModel.adicionarCardapio(controller.text.trim());
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cardápio "${controller.text.trim()}" criado!'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }



  void _showNovaListaDialog(HomeViewModel homeViewModel) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Lista de Compras'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nome da lista',
            hintText: 'Ex: Lista da Semana',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                homeViewModel.adicionarLista(controller.text.trim());
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lista "${controller.text.trim()}" criada!'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }


}