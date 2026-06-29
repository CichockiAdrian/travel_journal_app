import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/settings/data/app_settings_repository.dart';
import 'core/settings/logic/app_settings_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'features/photo_gallery/presentation/global_camera_overlay.dart';
import 'features/planned_places/background/planned_places_background_service.dart';
import 'firebase_options.dart';
import 'package:travel_journal_app/l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    await initializePlannedPlacesBackgroundService();
  }

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

class TravelJournalApp extends StatefulWidget {
  const TravelJournalApp({super.key});

  @override
  State<TravelJournalApp> createState() => _TravelJournalAppState();
}

class _TravelJournalAppState extends State<TravelJournalApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      WidgetsBinding.instance.removeObserver(this);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kIsWeb) {
      return;
    }

    final service = FlutterBackgroundService();

    if (state == AppLifecycleState.resumed) {
      service.invoke('setAppForeground', {'isForeground': true});
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      service.invoke('setAppForeground', {'isForeground': false});
    }
  }

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
