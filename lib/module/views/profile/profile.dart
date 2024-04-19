import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<String?>(
        future: _getUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String? userEmail = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 70,
                    // Display profile image or default image here
                    backgroundImage:
                        AssetImage('assets/default_profile_image.jpg'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    userEmail ?? 'User Email not found',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  // Add more user information widgets here
                  // Example: Username, bio, followers, etc.
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseHelper.logout(context);
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<String?> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}
