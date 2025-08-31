import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserActionsSectionWidget extends StatelessWidget {
  const UserActionsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Usuário',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (user != null) ...[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.photoURL != null 
                    ? NetworkImage(user.photoURL!) 
                    : null,
                  child: user.photoURL == null 
                    ? Text((user.displayName?.isNotEmpty == true ? user.displayName!.substring(0, 1).toUpperCase() : 'U'))
                    : null,
                ),
                title: Text(user.displayName ?? 'Usuário'),
                subtitle: Text(user.email ?? ''),
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
            ],
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              subtitle: const Text('Fazer logout da aplicação'),
              onTap: () {
                _showLogoutDialog(context);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text(
          'Tem certeza que deseja sair da aplicação?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Fecha o diálogo
              await FirebaseAuth.instance.signOut();
              // Volta para a tela de login e remove todas as telas anteriores
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}