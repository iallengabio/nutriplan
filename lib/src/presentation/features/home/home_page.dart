import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_viewmodel.dart';
import 'cardapios/cardapios_tab.dart';
import 'cardapios/criar_cardapio_screen.dart';
import 'listas/listas_tab.dart';
import '../settings/settings_page.dart';
import 'widgets/floating_action_button_menu.dart';
import 'widgets/custom_bottom_navigation_bar.dart';
import 'widgets/nova_lista_dialog.dart';

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
  late PageController _pageController;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
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



  @override
  void dispose() {
    _pageController.dispose();
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
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
            _tabIndicatorController.reset();
            _tabIndicatorController.forward();
          },
          children: const [
            CardapiosTab(),
            ListasTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButtonMenu(
        isFabMenuOpen: _isFabMenuOpen,
        fabAnimation: _fabAnimation,
        fabRotationAnimation: _fabRotationAnimation,
        onToggleFabMenu: _toggleFabMenu,
        onCloseFabMenu: _closeFabMenu,
        onShowNovaListaDialog: (homeViewModel) => NovaListaDialog.show(context),
        onShowNovoCardapioDialog: _showNovoCardapioDialog,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        tabIndicatorAnimation: _tabIndicatorAnimation,
        pageController: _pageController,
      ),
    );
  }

  void _showNovoCardapioDialog(HomeViewModel homeViewModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CriarCardapioScreen(),
      ),
    );
  }
}