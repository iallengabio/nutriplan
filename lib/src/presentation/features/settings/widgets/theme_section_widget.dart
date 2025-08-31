import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/settings.dart';
import '../../../../di.dart';
import '../settings_state.dart';

class ThemeSectionWidget extends ConsumerWidget {
  final Settings settings;

  const ThemeSectionWidget({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}