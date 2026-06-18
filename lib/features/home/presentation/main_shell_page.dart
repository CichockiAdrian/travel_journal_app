import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../account/presentation/account_page.dart';
import '../../countries/presentation/countries_page.dart';
import '../../map/presentation/map_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int currentIndex = 0;

  final pages = const [CountriesPage(), MapPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.public),
            label: translations.countries,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: translations.map,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: translations.account,
          ),
        ],
      ),
    );
  }
}
