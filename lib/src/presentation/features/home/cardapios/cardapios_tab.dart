import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di.dart';
import 'menu_viewmodel.dart';
import 'widgets/empty_cardapios_widget.dart';
import 'widgets/error_message_widget.dart';
import 'widgets/cardapio_card_widget.dart';

class CardapiosTab extends ConsumerStatefulWidget {
  const CardapiosTab({super.key});

  @override
  ConsumerState<CardapiosTab> createState() => _CardapiosTabState();
}

class _CardapiosTabState extends ConsumerState<CardapiosTab> {
  @override
  void initState() {
    super.initState();
    // Carrega os cardápios quando a aba é inicializada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuViewModelProvider.notifier).carregarMenus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuViewModelProvider);
    final menuViewModel = ref.read(menuViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meus Cardápios',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (menuState.menus.isNotEmpty)
                IconButton(
                  onPressed: () => menuViewModel.carregarMenus(),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Atualizar',
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (menuState.errorMessage != null)
            ErrorMessageWidget(
              errorMessage: menuState.errorMessage!,
              menuViewModel: menuViewModel,
            ),
          Expanded(
            child: _buildCardapiosList(context, menuState, menuViewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildCardapiosList(
    BuildContext context,
    MenuState menuState,
    MenuViewModel menuViewModel,
  ) {
    if (menuState.isLoading && menuState.menus.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (menuState.menus.isEmpty) {
      return const EmptyCardapiosWidget();
    }

    return RefreshIndicator(
      onRefresh: () => menuViewModel.carregarMenus(),
      child: ListView.builder(
        itemCount: menuState.menus.length,
        itemBuilder: (context, index) {
          final menu = menuState.menus[index];

          return CardapioCardWidget(menu: menu, menuViewModel: menuViewModel);
        },
      ),
    );
  }
}
