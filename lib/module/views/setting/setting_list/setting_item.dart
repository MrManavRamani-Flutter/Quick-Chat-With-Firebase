import 'package:flutter/material.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';

class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsListTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textColor),
      title: Text(title, style: const TextStyle(color: AppColors.textColor)),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 8.0,
      minVerticalPadding: 0.0,
    );
  }
}
