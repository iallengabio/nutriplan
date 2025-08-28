import '../../../domain/models/settings.dart';

sealed class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final Settings settings;
  const SettingsLoaded(this.settings);
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
}

class SettingsSaved extends SettingsState {
  const SettingsSaved();
}

sealed class SettingsCommand {
  const SettingsCommand();
}

class LoadSettingsCommand extends SettingsCommand {
  const LoadSettingsCommand();
}

class UpdateThemeCommand extends SettingsCommand {
  final ThemeMode themeMode;
  const UpdateThemeCommand(this.themeMode);
}

class ResetSettingsCommand extends SettingsCommand {
  const ResetSettingsCommand();
}