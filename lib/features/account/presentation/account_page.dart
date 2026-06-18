import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_journal_app/core/di/service_locator.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../../settings/presentation/settings_page.dart';
import '../logic/account_cubit.dart';
import '../models/account_menu_item.dart';
import '../models/account_menu_items.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountCubit>(
      create: (_) =>
          AccountCubit(authRepository: getIt<AuthRepository>())
            ..loadUserEmail(),
      child: const AccountView(),
    );
  }
}

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translations.account)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 36,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translations.user,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(state.email),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              ...accountMenuItems.map((item) {
                return Card(
                  child: ListTile(
                    leading: Icon(item.icon),
                    title: Text(_getMenuTitle(translations, item.type)),
                    subtitle: Text(_getMenuSubtitle(translations, item.type)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        _handleMenuItemTap(context, item.type, translations),
                  ),
                );
              }),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () => context.read<AccountCubit>().logout(),
                icon: const Icon(Icons.logout),
                label: state.isLoading
                    ? Text(translations.loggingOut)
                    : Text(translations.logout),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMenuTitle(
    AppLocalizations translations,
    AccountMenuItemType type,
  ) {
    switch (type) {
      case AccountMenuItemType.visitedCountries:
        return translations.visitedCountries;
      case AccountMenuItemType.travelJournal:
        return translations.travelJournal;
      case AccountMenuItemType.photos:
        return translations.photos;
      case AccountMenuItemType.settings:
        return translations.settings;
    }
  }

  String _getMenuSubtitle(
    AppLocalizations translations,
    AccountMenuItemType type,
  ) {
    switch (type) {
      case AccountMenuItemType.visitedCountries:
        return translations.visitedCountriesSubtitle;
      case AccountMenuItemType.travelJournal:
        return translations.travelJournalSubtitle;
      case AccountMenuItemType.photos:
        return translations.photosSubtitle;
      case AccountMenuItemType.settings:
        return translations.settingsSubtitle;
    }
  }

  void _handleMenuItemTap(
    BuildContext context,
    AccountMenuItemType type,
    AppLocalizations translations,
  ) {
    switch (type) {
      case AccountMenuItemType.settings:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
        break;

      case AccountMenuItemType.visitedCountries:
      case AccountMenuItemType.travelJournal:
      case AccountMenuItemType.photos:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(translations.comingSoon)));
        break;
    }
  }
}
