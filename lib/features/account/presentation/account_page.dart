import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          AccountCubit(authRepository: FirebaseAuthRepository())
            ..loadUserEmail(),
      child: const AccountView(),
    );
  }
}

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Konto')),
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
                        const Text(
                          'Użytkownik',
                          style: TextStyle(
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
                    title: Text(item.title),
                    subtitle: Text(item.subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _handleMenuItemTap(context, item.type),
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
                    ? const Text('Wylogowywanie...')
                    : const Text('Wyloguj się'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleMenuItemTap(BuildContext context, AccountMenuItemType type) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ta sekcja zostanie dodana później.')),
        );
        break;
    }
  }
}
