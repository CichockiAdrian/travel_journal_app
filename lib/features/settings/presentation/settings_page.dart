import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/settings/logic/app_settings_cubit.dart';
import '../../../l10n/generated/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(translations.settings)),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          final currentLanguageCode = state.locale.languageCode;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                translations.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              RadioGroup<String>(
                groupValue: currentLanguageCode,
                onChanged: (value) {
                  if (value == null) return;

                  context.read<AppSettingsCubit>().changeLanguage(value);
                },
                child: Column(
                  children: [
                    RadioListTile<String>(
                      value: 'pl',
                      title: Text(translations.polish),
                    ),
                    RadioListTile<String>(
                      value: 'en',
                      title: Text(translations.english),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                translations.theme,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<ThemeMode>(
                value: state.themeMode,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(translations.systemTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(translations.lightTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(translations.darkTheme),
                  ),
                ],
                onChanged: (themeMode) {
                  if (themeMode == null) return;

                  context.read<AppSettingsCubit>().changeThemeMode(themeMode);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
