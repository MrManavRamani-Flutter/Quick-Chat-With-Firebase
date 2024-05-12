import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/firebase_options.dart';
import 'package:quick_chat/module/views/chat/favorites_chat.dart';
import 'package:quick_chat/module/views/login_screen/login_screen.dart';
import 'package:quick_chat/module/views/login_screen/signup_screen.dart';
import 'package:quick_chat/module/views/setting/settings.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';
import 'package:quick_chat/module/views/welcome/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Chat',
      theme: AppTheme.themeData,
      initialRoute: 'welcome',
      routes: {
        'welcome': (context) => const SplashScreen(),
        'login': (context) => const LoginPage(),
        'signup': (context) => const SignUpScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:quick_chat/firebase_options.dart';
// import 'package:quick_chat/module/views/chat/favorites_chat.dart';
// import 'package:quick_chat/module/views/login_screen/login_screen.dart';
// import 'package:quick_chat/module/views/login_screen/signup_screen.dart';
// import 'package:quick_chat/module/views/setting/settings.dart';
// import 'package:quick_chat/module/views/welcome/splash_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Quick Chat',
//       initialRoute: "welcome",
//       routes: {
//         // "/": (context) => const HomeScreen(),
//         "welcome": (context) => const SplashScreen(),
//         "login": (context) => const LoginPage(),
//         "signup": (context) => const SignUpScreen(),
//         '/settings': (context) => const SettingsScreen(),
//         '/favorites': (context) => const FavoritesScreen(),
//         // '/chat': (context) => const ChatScreen(),
//       },
//     );
//   }
// }
