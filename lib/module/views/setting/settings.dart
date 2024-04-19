import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/module/views/profile/profile_screen.dart';
import 'package:quick_chat/module/views/setting/setting_list/setting_item.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.backgroundColor, AppColors.primaryColor],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          children: [
            SettingsListTile(
              icon: Icons.person,
              title: 'Profile',
              onTap: () async {
                // Fetch user ID here
                String? userId = await FirebaseHelper.getCurrentUserId();
                if (userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(userId: userId),
                    ),
                  );
                }
              },
            ),
            SettingsListTile(
              icon: Icons.block,
              title: 'Block List',
              onTap: () {
                Navigator.pushNamed(context, '/block_list');
              },
            ),
            SettingsListTile(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () async {
                await FirebaseHelper.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
