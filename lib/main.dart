import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'src/app.dart';
import 'src/di.dart';
import 'src/core/theme/app_theme.dart';
import 'src/domain/models/settings.dart' as settings_model;
import 'src/presentation/features/settings/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carregar variáveis de ambiente do arquivo .env
  await dotenv.load(fileName: ".env");
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsViewModel = ref.watch(settingsViewModelProvider);
    
    // Determina o tema baseado nas configurações
    ThemeMode themeMode = ThemeMode.system;
    if (settingsViewModel is SettingsLoaded) {
      final settings = (settingsViewModel).settings;
      switch (settings.themeMode) {
        case settings_model.ThemeMode.light:
          themeMode = ThemeMode.light;
          break;
        case settings_model.ThemeMode.dark:
          themeMode = ThemeMode.dark;
          break;
        case settings_model.ThemeMode.system:
          themeMode = ThemeMode.system;
          break;
      }
    }
    
    return MaterialApp(
      title: 'NutriPlan',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const AppWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
