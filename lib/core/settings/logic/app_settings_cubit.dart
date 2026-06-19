import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/app_settings_repository.dart';

class AppSettingsState {
  final Locale locale;
  final ThemeMode themeMode;
  final bool isLoading;

  const AppSettingsState({
    required this.locale,
    required this.themeMode,
    required this.isLoading,
  });

  const AppSettingsState.initial()
    : locale = const Locale('pl'),
      themeMode = ThemeMode.system,
      isLoading = true;

  AppSettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? isLoading,
  }) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final AppSettingsRepository appSettingsRepository;

  AppSettingsCubit({required this.appSettingsRepository})
    : super(const AppSettingsState.initial());

  Future<void> loadSettings() async {
    final savedLanguageCode = await appSettingsRepository
        .getSavedLanguageCode();

    emit(
      state.copyWith(
        locale: Locale(savedLanguageCode ?? 'pl'),
        isLoading: false,
      ),
    );
  }

  Future<void> changeLanguage(String languageCode) async {
    await appSettingsRepository.saveLanguageCode(languageCode);

    emit(state.copyWith(locale: Locale(languageCode)));
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    await appSettingsRepository.saveThemeMode(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }
}
