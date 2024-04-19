import 'package:flutter/material.dart';
import 'package:quick_chat/module/views/profile/profile.dart';
import 'package:quick_chat/module/views/profile/profile_helper.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserProfile?>(
        future: ProfileHelper.fetchUserProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            UserProfile? userProfile = snapshot.data;
            if (userProfile != null) {
              return buildProfile(context, userProfile);
            } else {
              return const Center(child: Text('User profile not found'));
            }
          }
        },
      ),
    );
  }

  Widget buildProfile(BuildContext context, UserProfile userProfile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage('${userProfile.profileUrl}'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Username: ${userProfile.username}'),
          Text('Email: ${userProfile.email}'),
          // Display other profile information as needed
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:quick_chat/module/views/profile/profile.dart';
// import 'package:quick_chat/module/views/profile/profile_helper.dart';
//
// class ProfileScreen extends StatelessWidget {
//   final String userId;
//
//   const ProfileScreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: FutureBuilder<UserProfile?>(
//         future: ProfileHelper.fetchUserProfile(userId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             UserProfile? userProfile = snapshot.data;
//             if (userProfile != null) {
//               return buildProfile(userProfile);
//             } else {
//               return const Center(child: Text('User profile not found'));
//             }
//           }
//         },
//       ),
//     );
//   }
//
//   Widget buildProfile(UserProfile userProfile) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Username: ${userProfile.username}'),
//           Text('Email: ${userProfile.email}'),
//           // Display other profile information as needed
//         ],
//       ),
//     );
//   }
// }
