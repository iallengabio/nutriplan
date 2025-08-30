import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_viewmodel.dart';
import 'cardapios/cardapios_tab.dart';
import 'cardapios/criar_cardapio_screen.dart';
import 'listas/listas_tab.dart';
import 'listas/create_shopping_list_page.dart';
import '../shopping/pages/create_shopping_list_from_menu_page.dart';

import '../settings/settings_page.dart';

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
  late AnimationController _tabIndicatorController;
  late Animation<double> _tabIndicatorAnimation;
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
    _tabIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _tabIndicatorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tabIndicatorController, curve: Curves.elasticOut),
    );
    // Inicializa a animação para a primeira aba
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabIndicatorController.forward();
    });
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
    _tabIndicatorController.dispose();
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

  Widget _buildCustomBottomNavigationBar() {
    const tabItems = [
      {'icon': Icons.restaurant_menu, 'label': 'Cardápios'},
      {'icon': Icons.shopping_cart, 'label': 'Listas'},
    ];

    const double barHeight = 85;
    const double indicatorHeight = 32;

    return Container(
      height: barHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Indicador animado
          AnimatedBuilder(
            animation: _tabIndicatorAnimation,
            builder: (context, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                left: (_currentIndex * (MediaQuery.of(context).size.width / 2)) + 
                       (MediaQuery.of(context).size.width / 4) - 25,
                 top: (barHeight / 2) - (indicatorHeight / 2) - 8, // Alinha com o centro dos ícones
                child: Transform.scale(
                  scale: 0.8 + (0.2 * _tabIndicatorAnimation.value),
                  child: Container(
                    width: 50,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              );
            },
          ),
          // Itens da navegação
          Row(
            children: List.generate(tabItems.length, (index) {
              final item = tabItems[index];
              final isSelected = _currentIndex == index;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_currentIndex != index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      _tabIndicatorController.reset();
                      _tabIndicatorController.forward();
                    }
                  },
                  child: Container(
                    height: barHeight,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                           padding: const EdgeInsets.all(8),
                           child: Icon(
                             item['icon'] as IconData,
                             color: isSelected 
                                 ? Theme.of(context).colorScheme.primary
                                 : Theme.of(context).colorScheme.onSurfaceVariant,
                             size: 24,
                           ),
                         ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                           duration: const Duration(milliseconds: 200),
                           style: TextStyle(
                             fontSize: 11,
                             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                             color: isSelected 
                                 ? Theme.of(context).colorScheme.primary
                                 : Theme.of(context).colorScheme.onSurfaceVariant,
                           ),
                           child: Text(item['label'] as String),
                         ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
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
          ],
        ),
      ),
      floatingActionButton: _buildFabWithMenu(),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
    );
  }











  void _showNovoCardapioDialog(HomeViewModel homeViewModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CriarCardapioScreen(),
      ),
    );
  }



  void _showNovaListaDialog(HomeViewModel homeViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Lista de Compras'),
        content: const Text('Como você gostaria de criar a lista?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateShoppingListFromMenuPage(),
                ),
              );
            },
            child: const Text('Baseada em Cardápio'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateShoppingListPage(),
                ),
              );
            },
            child: const Text('Lista Manual'),
          ),
        ],
      ),
    );
  }


}