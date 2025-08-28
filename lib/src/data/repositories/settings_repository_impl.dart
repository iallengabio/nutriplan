import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const String _settingsKey = 'app_settings';

  @override
  Future<Settings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson != null) {
      try {
        final Map<String, dynamic> json = {
          'themeMode': settingsJson,
        };
        return Settings.fromJson(json);
      } catch (e) {
        // Se houver erro na deserialização, retorna configurações padrão
        return const Settings();
      }
    }
    
    return const Settings();
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, settings.themeMode.name);
  }

  @override
  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsKey);
  }
}