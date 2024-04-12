import 'package:flutter/material.dart';
import 'package:quick_chat/module/utils/user_info.dart';
import 'package:quick_chat/module/views/users_ui/user_list.dart';

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
          children: [
            ...Users.users.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 7.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('chat_screen', arguments: e);
                    },
                    child: ProfileAvatar(
                      imageUrl: e.profileImage,
                      username: e.username,
                    ),
                  ),
                  const SizedBox(height: 7.0),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
