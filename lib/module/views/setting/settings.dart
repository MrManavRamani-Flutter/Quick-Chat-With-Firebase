import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/module/views/profile/profile_screen.dart';
import 'package:quick_chat/module/views/setting/setting_list/setting_item.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.gradientStart.withOpacity(0.2),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SettingsListTile(
              icon: Icons.person,
              title: 'Profile',
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
                String? currentUserEmail = prefs.getString('email');
                if (isLoggedIn) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(currentUserEmail: currentUserEmail!),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ProfileScreen(currentUserEmail: "No Data"),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
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
