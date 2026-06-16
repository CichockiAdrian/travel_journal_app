import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/account_menu_item.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  List<AccountMenuItem> _buildMenuItems() {
    return const [
      AccountMenuItem(
        icon: Icons.public, 
        title: 'Odwiedzone kraje', 
        subtitle: 'Lista krajów oznaczonych jako odwiedzone',
        ),
      AccountMenuItem(
        icon: Icons.book_outlined,
        title: 'Diennik podróży',
        subtitle: 'Wpisy i wspomnienia z wyjazdów',
        ),
      AccountMenuItem(
        icon: Icons.image_outlined, 
        title: 'Zdjęcia', 
        subtitle: 'Zdjęcia dodane z podróży',
        ),
      AccountMenuItem(
        icon: Icons.settings_outlined, 
        title: 'Ustawienia', 
        subtitle: 'Preferencje aplikacji',
        ),
    ];
  }

  @override 
  Widget build(BuildContext context){
    final user = FirebaseAuth.instance.currentUser;
    final menuItems = _buildMenuItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konto'),
      ),
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
                    Text(user?.email ?? 'Brak adresu email'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ...menuItems.map(
            (item) {
              return Card(
                child: ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              );
            },
          ),
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