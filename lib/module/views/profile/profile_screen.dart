import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/module/views/profile/profile.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserEmail;
  const ProfileScreen({super.key, required this.currentUserEmail});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: FirebaseHelper.fetchUserData(widget.currentUserEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userList = snapshot.data!;
            return ProfileDetail(
              email: widget.currentUserEmail,
              username: userList[0]['username'],
              imageUrl: userList[0]['imageUrl'],
              bio: userList[0]['bio'],
            );
          }
        },
      ),
    );
  }
}
