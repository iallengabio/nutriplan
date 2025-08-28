import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/settings.dart';
import '../../../domain/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsViewModel extends StateNotifier<SettingsState> {
  final SettingsRepository _settingsRepository;
  Settings? _currentSettings;

  SettingsViewModel(this._settingsRepository) : super(const SettingsInitial());

  Settings? get currentSettings => _currentSettings;

  Future<void> executeCommand(SettingsCommand command) async {
    switch (command) {
      case LoadSettingsCommand():
        await _loadSettings();
        break;
      case UpdateThemeCommand(themeMode: final themeMode):
        await _updateTheme(themeMode);
        break;
      case ResetSettingsCommand():
        await _resetSettings();
        break;
    }
  }

  Future<void> _loadSettings() async {
    try {
      state = const SettingsLoading();
      final settings = await _settingsRepository.loadSettings();
      _currentSettings = settings;
      state = SettingsLoaded(settings);
    } catch (e) {
      state = SettingsError('Erro ao carregar configurações: ${e.toString()}');
    }
  }

  Future<void> _updateTheme(ThemeMode themeMode) async {
    try {
      if (_currentSettings == null) {
        await _loadSettings();
      }
      
      final updatedSettings = _currentSettings!.copyWith(themeMode: themeMode);
      await _settingsRepository.saveSettings(updatedSettings);
      _currentSettings = updatedSettings;
      state = const SettingsSaved();
      state = SettingsLoaded(updatedSettings);
    } catch (e) {
      state = SettingsError('Erro ao atualizar tema: ${e.toString()}');
    }
  }



  Future<void> _resetSettings() async {
    try {
      state = const SettingsLoading();
      await _settingsRepository.resetSettings();
      final defaultSettings = const Settings();
      _currentSettings = defaultSettings;
      state = const SettingsSaved();
      state = SettingsLoaded(defaultSettings);
    } catch (e) {
      state = SettingsError('Erro ao resetar configurações: ${e.toString()}');
    }
  }



  void resetState() {
    state = const SettingsInitial();
  }


}