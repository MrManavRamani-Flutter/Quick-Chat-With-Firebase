// bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:quick_chat/module/views/search_user/search_users.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';

class BottomNavigation extends StatelessWidget {
  final String currentUserEmail;
  const BottomNavigation({super.key, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: AppTheme.textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SearchScreen(currentUserEmail: currentUserEmail),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_reaction_outlined, color: Colors.grey),
            onPressed: () {
              // Uncomment and implement when AddFriend screen is available
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         AddFriend(currentUserEmail: currentUserEmail),
              //   ),
              // );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.textColor),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
