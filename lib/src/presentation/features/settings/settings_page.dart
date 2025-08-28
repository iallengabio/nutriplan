import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/models/settings.dart';
import '../../../di.dart';
import 'settings_state.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsViewModelProvider.notifier)
          .executeCommand(const LoadSettingsCommand());
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SettingsState>(settingsViewModelProvider, (previous, next) {
      switch (next) {
        case SettingsError(message: final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
          break;
        case SettingsSaved():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Configurações salvas com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          break;
        default:
          break;
      }
    });

    final state = ref.watch(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(SettingsState state) {
    switch (state) {
      case SettingsInitial():
      case SettingsLoading():
        return const Center(
          child: CircularProgressIndicator(),
        );
      case SettingsLoaded(settings: final settings):
        return _buildSettingsContent(settings);
      case SettingsError(message: final message):
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Erro ao carregar configurações',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(settingsViewModelProvider.notifier)
                      .executeCommand(const LoadSettingsCommand());
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        );
      case SettingsSaved():
        return _buildSettingsContent(
          ref.read(settingsViewModelProvider.notifier).currentSettings ?? const Settings(),
        );
    }
  }

  Widget _buildSettingsContent(Settings settings) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildThemeSection(settings),
        const SizedBox(height: 24),
        _buildActionsSection(),
      ],
    );
  }

  Widget _buildThemeSection(Settings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Aparência',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Tema do aplicativo',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            ...ThemeMode.values.map((mode) => RadioListTile<ThemeMode>(
                  title: Text(mode.displayName),
                  subtitle: Text(mode.description),
                  value: mode,
                  groupValue: settings.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(settingsViewModelProvider.notifier)
                          .executeCommand(UpdateThemeCommand(value));
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                )),
          ],
        ),
      ),
    );
  }



  Widget _buildActionsSection() {
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
                    ? Text(user.displayName?.substring(0, 1).toUpperCase() ?? 'U')
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
                _showLogoutDialog();
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
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
              if (mounted) {
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