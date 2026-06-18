import 'package:flutter/material.dart';

import 'account_menu_item.dart';

const accountMenuItems = [
  AccountMenuItem(
    icon: Icons.public,
    type: AccountMenuItemType.visitedCountries,
  ),
  AccountMenuItem(
    icon: Icons.book_outlined,
    type: AccountMenuItemType.travelJournal,
  ),
  AccountMenuItem(icon: Icons.image_outlined, type: AccountMenuItemType.photos),
  AccountMenuItem(
    icon: Icons.settings_outlined,
    type: AccountMenuItemType.settings,
  ),
];
