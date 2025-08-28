class Settings {
  final ThemeMode themeMode;

  const Settings({
    this.themeMode = ThemeMode.system,
  });

  Settings copyWith({
    ThemeMode? themeMode,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Settings &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode {
    return themeMode.hashCode;
  }
}

enum ThemeMode {
  light,
  dark,
  system,
}

extension ThemeModeExtension on ThemeMode {
  String get displayName {
    switch (this) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
      case ThemeMode.system:
        return 'Automático';
    }
  }

  String get description {
    switch (this) {
      case ThemeMode.light:
        return 'Tema claro sempre ativo';
      case ThemeMode.dark:
        return 'Tema escuro sempre ativo';
      case ThemeMode.system:
        return 'Segue o tema do sistema';
    }
  }
}