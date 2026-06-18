import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/app_settings_repository.dart';

class AppSettingsState {
  final Locale locale;
  final bool isLoading;

  const AppSettingsState({required this.locale, required this.isLoading});

  const AppSettingsState.initial()
    : locale = const Locale('pl'),
      isLoading = true;

  AppSettingsState copyWith({Locale? locale, bool? isLoading}) {
    return AppSettingsState(
      locale: locale ?? this.locale,
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
}
