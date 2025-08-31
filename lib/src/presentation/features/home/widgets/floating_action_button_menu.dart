import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home_viewmodel.dart';

class FloatingActionButtonMenu extends ConsumerWidget {
  final bool isFabMenuOpen;
  final Animation<double> fabAnimation;
  final Animation<double> fabRotationAnimation;
  final VoidCallback onToggleFabMenu;
  final VoidCallback onCloseFabMenu;
  final Function(HomeViewModel) onShowNovaListaDialog;
  final Function(HomeViewModel) onShowNovoCardapioDialog;

  const FloatingActionButtonMenu({
    super.key,
    required this.isFabMenuOpen,
    required this.fabAnimation,
    required this.fabRotationAnimation,
    required this.onToggleFabMenu,
    required this.onCloseFabMenu,
    required this.onShowNovaListaDialog,
    required this.onShowNovoCardapioDialog,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Menu items
        AnimatedBuilder(
          animation: fabAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: fabAnimation.value,
              child: Opacity(
                opacity: fabAnimation.value,
                child: Visibility(
                  visible: fabAnimation.value > 0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: FloatingActionButton.extended(
                      heroTag: "fab_lista",
                      onPressed: () {
                        onCloseFabMenu();
                        onShowNovaListaDialog(homeViewModel);
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
          animation: fabAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: fabAnimation.value,
              child: Opacity(
                opacity: fabAnimation.value,
                child: Visibility(
                  visible: fabAnimation.value > 0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: FloatingActionButton.extended(
                      heroTag: "fab_cardapio",
                      onPressed: () {
                        onCloseFabMenu();
                        onShowNovoCardapioDialog(homeViewModel);
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
          animation: fabRotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: fabRotationAnimation.value * 2 * 3.14159,
              child: FloatingActionButton(
                heroTag: "main_fab",
                onPressed: onToggleFabMenu,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Icon(
                  isFabMenuOpen ? Icons.close : Icons.add,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}