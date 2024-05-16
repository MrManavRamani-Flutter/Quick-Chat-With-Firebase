import 'package:flutter/material.dart';
import 'package:quick_chat/model/user_model.dart';

class UserProfileInfo extends StatelessWidget {
  final UserData user;

  const UserProfileInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[200],
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            user.username,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.bio,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
