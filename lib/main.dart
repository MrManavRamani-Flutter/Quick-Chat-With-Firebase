import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/firebase_options.dart';
import 'package:quick_chat/module/views/chat/chat_screen.dart';
import 'package:quick_chat/module/views/login_screen/login_screen.dart';
import 'package:quick_chat/module/views/login_screen/signup_screen.dart';
import 'package:quick_chat/module/views/profile/user_profile/user_profile.dart';
import 'package:quick_chat/module/views/screens/home_screen.dart';
import 'package:quick_chat/module/views/welcome/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Chat',
      // initialRoute: "welcome",
      routes: {
        "/": (context) => const HomeScreen(),
        "welcome": (context) => const SplashScreen(),
        "login": (context) => const LoginPage(),
        "signup": (context) => const SignUpScreen(),
        "chat_screen": (context) => const ChatScreen(),
        "user_profile": (context) => const ProfileScreen(),
      },
    );
  }
}
