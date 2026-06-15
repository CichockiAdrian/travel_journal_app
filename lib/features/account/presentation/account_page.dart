import 'package:flutter/material.dart';

import '../../auth/presentation/login_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.public,
        'title': 'Odwiedzone kraje',
        'subtitle': 'Lista krajów oznaczonych jako odwiedzone',
      },
      {
        'icon': Icons.book_outlined,
        'title': 'Dziennik podróży',
        'subtitle': 'Wpisy i wspomnienia z wyjazdów',
      },
      {
        'icon': Icons.image_outlined,
        'title': 'Zdjęcia',
        'subtitle': 'Zdjęcia dodane do podróży',
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Ustawienia',
        'subtitle': 'Preferencje aplikacji',
      },
    ];

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
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 36,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adrian',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('adrian@example.com'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ...menuItems.map((item) {
            return Card(
              child: ListTile(
                leading: Icon(item['icon'] as IconData),
                title: Text(item['title'] as String),
                subtitle: Text(item['subtitle'] as String),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            );
          }),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Wyloguj się'),
          ),
        ],
      ),
    );
  }
}
