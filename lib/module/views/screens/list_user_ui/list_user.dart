import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/module/views/chat/chat_screen.dart';

class UserDataListWidget extends StatelessWidget {
  final String currentUserEmail;
  const UserDataListWidget({super.key, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: FirebaseHelper.fetchAllUserData(currentUserEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userList = snapshot.data!;
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final userData = userList[index].data() as Map<String, dynamic>;
              final username = userData['username'] ?? 'Unknown';
              final email = userData['email'] ?? 'Unknown';
              return ListTile(
                title: Text(username),
                subtitle: Text(email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        username: username,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
