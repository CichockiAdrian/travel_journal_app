import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'firebase_options.dart';
import 'core/di/service_locator.dart';

import 'package:travel_journal_app/l10n/generated/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/settings/data/app_settings_repository.dart';
import 'core/settings/logic/app_settings_cubit.dart';

import 'features/photo_gallery/presentation/global_camera_overlay.dart';
import 'features/planned_places/background/planned_places_background_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializePlannedPlacesBackgroundService();

  setupServiceLocator();

  runApp(
    BlocProvider(
      create: (_) =>
          AppSettingsCubit(appSettingsRepository: AppSettingsRepository())
            ..loadSettings(),
      child: const TravelJournalApp(),
    ),
  );
}

class TravelJournalApp extends StatelessWidget {
  const TravelJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, state) {
        return MaterialApp(
          builder: (context, child) {
            return GlobalCameraOverlay(child: child ?? const SizedBox.shrink());
          },
          title: 'Travel Journal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.themeMode,
          locale: state.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AuthGate(),
        );
      },
    );
  }
}
