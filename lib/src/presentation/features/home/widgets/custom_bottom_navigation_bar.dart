import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Animation<double> tabIndicatorAnimation;
  final PageController pageController;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.tabIndicatorAnimation,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
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
            animation: tabIndicatorAnimation,
            builder: (context, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                left: (currentIndex * (MediaQuery.of(context).size.width / 2)) + 
                       (MediaQuery.of(context).size.width / 4) - 25,
                 top: (barHeight / 2) - (indicatorHeight / 2) - 8, // Alinha com o centro dos ícones
                child: Transform.scale(
                  scale: 0.8 + (0.2 * tabIndicatorAnimation.value),
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
              final isSelected = currentIndex == index;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (currentIndex != index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
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
}