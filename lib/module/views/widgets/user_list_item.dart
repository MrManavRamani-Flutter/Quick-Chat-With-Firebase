// user_list_item.dart
import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/model/user_model.dart';
import 'package:quick_chat/module/views/chat/chat_screen.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';

class UserListItem extends StatelessWidget {
  final AnimationController animationController;
  final String currentUserEmail;
  final UserData userData;

  const UserListItem({
    super.key,
    required this.animationController,
    required this.currentUserEmail,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final chatRoomId =
        FirebaseHelper.getChatRoomId(currentUserEmail, userData.email);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiverUser: userData,
              receiverUsername: userData.username,
              currentUserEmail: currentUserEmail,
              chatRoomId: chatRoomId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            const BoxShadow(
                color: Colors.blueAccent,
                blurRadius: 15,
                blurStyle: BlurStyle.outer),
            BoxShadow(
                color: Colors.pinkAccent.withOpacity(0.3),
                blurRadius: 1,
                blurStyle: BlurStyle.normal),
          ],
          color: AppTheme.backgroundColor.withOpacity(0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.07,
                backgroundColor: AppTheme.backgroundColor,
                backgroundImage: userData.imageUrl.isNotEmpty
                    ? NetworkImage(userData.imageUrl)
                    : const AssetImage('assets/img/users/unu.png')
                        as ImageProvider,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData.username,
                    style: AppTheme.titleMedium
                        .copyWith(color: AppTheme.textColor),
                  ),
                  Text(
                    userData.email,
                    style:
                        AppTheme.bodyMedium.copyWith(color: AppTheme.textColor),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textColor),
          ],
        ),
      ),
    );
  }
}
