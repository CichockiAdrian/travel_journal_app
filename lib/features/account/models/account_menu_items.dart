import 'package:flutter/material.dart';

import 'account_menu_item.dart';

const accountMenuItems = [
  AccountMenuItem(
    icon: Icons.public,
    title: 'Odwiedzone kraje',
    subtitle: 'Lista krajów oznaczonych jako odwiedzone',
    type: AccountMenuItemType.visitedCountries,
  ),
  AccountMenuItem(
    icon: Icons.book_outlined,
    title: 'Dziennik podróży',
    subtitle: 'Wpisy i wspomnienia z wyjazdów',
    type: AccountMenuItemType.travelJournal,
  ),
  AccountMenuItem(
    icon: Icons.image_outlined,
    title: 'Zdjęcia',
    subtitle: 'Zdjęcia dodane do podróży',
    type: AccountMenuItemType.photos,
  ),
  AccountMenuItem(
    icon: Icons.settings_outlined,
    title: 'Ustawienia',
    subtitle: 'Preferencje aplikacji',
    type: AccountMenuItemType.settings,
  ),
];
