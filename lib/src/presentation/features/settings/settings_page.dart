import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/models/settings.dart';
import '../../../di.dart';
import 'settings_state.dart';
import 'widgets/api_usage_widget.dart';
import 'widgets/theme_section_widget.dart';
import 'widgets/user_actions_section_widget.dart';
import '../profile/family_profile_page.dart';

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
      body: switch (state) {
        SettingsInitial() || SettingsLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        SettingsLoaded(settings: final settings) => _buildSettingsContent(settings),
        SettingsError(message: final message) => Center(
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
        ),
        SettingsSaved() => _buildSettingsContent(
          ref.read(settingsViewModelProvider.notifier).currentSettings ?? const Settings(),
        ),
      },
    );
  }

  Widget _buildSettingsContent(Settings settings) {
    final user = FirebaseAuth.instance.currentUser;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ThemeSectionWidget(settings: settings),
        const SizedBox(height: 24),
        if (user != null) ...[
          _buildFamilyProfileSection(),
          const SizedBox(height: 24),
          const ApiUsageWidget(),
          const SizedBox(height: 24),
        ],
        const UserActionsSectionWidget()
      ],
    );
  }

  Widget _buildFamilyProfileSection() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.family_restroom,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Perfil Familiar'),
        subtitle: const Text('Configure o perfil da sua família para cardápios personalizados'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FamilyProfilePage(),
            ),
          );
        },
      ),
    );
  }
}