import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(const TravelJournalApp());
}

class TravelJournalApp extends StatelessWidget {
  const TravelJournalApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Journal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}
