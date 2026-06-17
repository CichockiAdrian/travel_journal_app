import 'package:flutter/material.dart';

enum AccountMenuItemType { visitedCountries, travelJournal, photos, settings }

class AccountMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final AccountMenuItemType type;

  const AccountMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.type,
  });
}
