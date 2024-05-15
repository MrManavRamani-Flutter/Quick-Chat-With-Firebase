import 'package:flutter/material.dart';
import 'package:quick_chat/model/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final UserData user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.imageUrl.isNotEmpty)
              CircleAvatar(
                backgroundImage: NetworkImage(user.imageUrl),
                radius: 50,
              ),
            const SizedBox(height: 16),
            Text(
              'Username: ${user.username}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Bio: ${user.bio}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
