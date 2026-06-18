import 'package:flutter/material.dart';

enum AccountMenuItemType { visitedCountries, travelJournal, photos, settings }

class AccountMenuItem {
  final IconData icon;
  final AccountMenuItemType type;

  const AccountMenuItem({required this.icon, required this.type});
}
