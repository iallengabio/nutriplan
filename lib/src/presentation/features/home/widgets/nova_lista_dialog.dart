import 'package:flutter/material.dart';

import '../../shopping/pages/create_shopping_list_from_menu_page.dart';
import '../listas/create_shopping_list_page.dart';

class NovaListaDialog extends StatelessWidget {
  const NovaListaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const NovaListaDialog(),
    );
  }
}