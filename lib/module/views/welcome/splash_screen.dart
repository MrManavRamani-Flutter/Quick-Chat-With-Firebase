import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_chat/module/views/login_screen/login_screen.dart';
import 'package:quick_chat/module/views/screens/home_screen.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      _checkFirstTimeUser,
    );
  }

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? currentUserEmail = prefs.getString('email');
    if (isLoggedIn) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(currentUserEmail: currentUserEmail!),
          ),
        );
      }
    } else {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: AppTheme.gradientBackground,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat,
                size: 100,
                color: AppTheme.textColor,
              ),
              SizedBox(height: 24),
              Text(
                'Quick Chat',
                style: AppTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
