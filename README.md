    # quick_chat

A new Flutter project.

## Getting Started

## Step 01 :
    ##create Structure of app 
        -## lib/
            |
            |---->## module/
            |       |
            |       |---> ## modules/
            |       |            
            |       |---------> ## views/
            |                        |
            |                        |----> ## Login_screen/
            |                        |           |
            |                        |           |----> ## login_screen.dart
            |                        |           |----> ## signup_screen.dart
            |                        |
            |                        |----> ## Screens/
            |                        |            |
            |                        |            |----> ## home_screen.dart
            |                        |
            |                        |----> ## Welcome/
            |                                    |
            |                                    |----> ## splash_screen.dart
            |                
            |------> ## firebase_options.dart                
            |
            |------> ## main.dart


## Coding Steps :
    ## Step 01 : { Splash Screen Code or design }
            import 'package:flutter/material.dart';
            import 'package:quick_chat/module/views/screens/home_screen.dart';
            import 'dart:async';
            
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
                  () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const HomeScreen(),
                      ),
                    );
                  },
                );
              }
            
              @override
              Widget build(BuildContext context) {
                return const Scaffold(
                  backgroundColor: Colors.blue,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          size: 100,
                          color: Colors.white,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Quick Chat',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }



A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
