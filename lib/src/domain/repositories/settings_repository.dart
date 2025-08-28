import '../models/settings.dart';

abstract class SettingsRepository {
  /// Carrega as configurações salvas
  Future<Settings> loadSettings();
  
  /// Salva as configurações
  Future<void> saveSettings(Settings settings);
  
  /// Reseta as configurações para o padrão
  Future<void> resetSettings();
}