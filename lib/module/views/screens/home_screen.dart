import 'package:flutter/material.dart';
import 'package:quick_chat/module/views/chat/chat_screen.dart';
import 'package:quick_chat/module/views/profile_screen/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              child: const ProfileAvatar(
                imageUrl:
                    'https://static.vecteezy.com/system/resources/previews/019/900/322/non_2x/happy-young-cute-illustration-face-profile-png.png',
                username: 'JohnDoe',
              ),
            ),
            const SizedBox(height: 20.0),
            const ProfileAvatar(
              imageUrl:
                  'https://static.vecteezy.com/system/resources/previews/019/900/322/non_2x/happy-young-cute-illustration-face-profile-png.png',
              username: 'JohnDoe',
            ),
            const SizedBox(height: 20.0),
            const ProfileAvatar(
              imageUrl:
                  'https://static.vecteezy.com/system/resources/previews/019/900/322/non_2x/happy-young-cute-illustration-face-profile-png.png',
              username: 'JohnDoe',
            ),
            const SizedBox(height: 20.0),
            const ProfileAvatar(
              imageUrl:
                  'https://static.vecteezy.com/system/resources/previews/019/900/322/non_2x/happy-young-cute-illustration-face-profile-png.png',
              username: 'JohnDoe',
            ),
            const SizedBox(height: 20.0),
            const ProfileAvatar(
              imageUrl:
                  'https://static.vecteezy.com/system/resources/previews/019/900/322/non_2x/happy-young-cute-illustration-face-profile-png.png',
              username: 'JohnDoe',
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
