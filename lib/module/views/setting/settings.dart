import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/module/views/profile/profile_screen.dart';
import 'package:quick_chat/module/views/setting/setting_list/setting_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        children: [
          SettingsListTile(
            icon: Icons.person,
            title: 'Profile',
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
              String? currentUserEmail = prefs.getString('email');
              if (isLoggedIn) {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(currentUserEmail: currentUserEmail!),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ProfileScreen(currentUserEmail: "No Data"),
                    ),
                  );
                }
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
    );
  }
}
