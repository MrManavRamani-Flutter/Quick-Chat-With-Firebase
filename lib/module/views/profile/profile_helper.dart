import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_chat/module/views/profile/profile.dart';

class ProfileHelper {
  static Future<UserProfile?> fetchUserProfile(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        return UserProfile(
          username: data['username'],
          email: data['email'],
          profileUrl: "https://static.thenounproject.com/png/676465-200.png",
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
}
