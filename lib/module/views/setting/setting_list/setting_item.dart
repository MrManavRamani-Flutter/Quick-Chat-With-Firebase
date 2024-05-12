import 'package:flutter/material.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';

class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textColor, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTheme.titleSmall,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class SettingsListTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;
//
//   const SettingsListTile(
//       {super.key,
//       required this.icon,
//       required this.title,
//       required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(title, style: const TextStyle(color: Colors.black)),
//       onTap: onTap,
//       contentPadding:
//           const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       visualDensity: VisualDensity.compact,
//       horizontalTitleGap: 8.0,
//       minVerticalPadding: 0.0,
//     );
//   }
// }
