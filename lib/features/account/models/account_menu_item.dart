import 'package:flutter/material.dart';

class AccountMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const AccountMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}
