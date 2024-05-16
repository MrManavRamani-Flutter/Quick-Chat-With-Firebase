import 'package:flutter/material.dart';

import 'profile_stat_column.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String? bio;
  final String? imageUrl;
  final int postCount;
  final int friendsCount;
  final String email;

  const ProfileHeader({
    super.key,
    required this.username,
    this.imageUrl,
    this.bio,
    required this.postCount,
    required this.friendsCount,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    imageUrl!.isNotEmpty ? NetworkImage(imageUrl!) : null,
                child: imageUrl!.isEmpty ? const FlutterLogo() : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileStatColumn(label: 'Posts', value: postCount),
                  const SizedBox(width: 20),
                  ProfileStatColumn(label: 'Friends', value: friendsCount),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            username,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            bio ?? "",
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
