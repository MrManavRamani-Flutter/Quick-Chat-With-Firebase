import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quick_chat/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHelper {
  // User Search -------------------------------------
  static Future<List<UserData>> searchUsers(String query) async {
    try {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: query)
              .where('username', isLessThan: '${query}z')
              .get();

      List<UserData> users = usersSnapshot.docs.map((doc) {
        Map<String, dynamic> userData = doc.data();
        return UserData(
          username: userData['username'] ?? '',
          bio: userData['bio'] ?? '',
          imageUrl: userData['imageUrl'] ?? '',
        );
      }).toList();

      return users;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  static Future<UserData> getUserData(String email) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (userDataSnapshot.exists) {
        Map<String, dynamic> userDataMap = userDataSnapshot.data()!;
        return UserData(
          username: userDataMap['username'] ?? '',
          bio: userDataMap['bio'] ?? '',
          imageUrl: userDataMap['imageUrl'] ?? '',
        );
      } else {
        // User data not found, return default values
        return UserData(
          username: '',
          bio: '',
          imageUrl: '',
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Return default values if an error occurs
      return UserData(
        username: '',
        bio: '',
        imageUrl: '',
      );
    }
  }

  static Future<String?> uploadProfileImage(File imageFile) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  static Future<void> setProfile(
      String username, String email, String bio, String imageUrl) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String userId = snapshot.docs[0].id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'username': username,
          'bio': bio,
          'imageUrl': imageUrl,
        });
      }
    } catch (e) {
      print('Error setting profile: $e');
      rethrow;
    }
  }

  static final Logger _logger = Logger();

  static String getChatRoomId(String user1Email, String user2Email) {
    List<String> users = [user1Email, user2Email];
    users.sort();
    return '${users[0]}_${users[1]}';
  }

  static Future<bool> loginUser(String email, String password) async {
    try {
      // UserCredential userCredential =
      //     await FirebaseAuth.insta nce.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      await _saveUserDataToSharedPreferences(email);

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      _logger.e('Login error: $e');
      return false;
    }
  }

  static Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await _clearUserDataFromSharedPreferences();
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('login', (route) => false);
      }
    } catch (e) {
      _logger.e('Error logging out: $e');
    }
  }

  static Future<void> signUpUser(
      String username, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      Timestamp timestamp = Timestamp.now();

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'createdAt': timestamp,
        'password': password,
      });
    } catch (e) {
      _logger.e('Signup error: $e');
      rethrow;
    }
  }

  static Future<void> _saveUserDataToSharedPreferences(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<void> _clearUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.setBool('isLoggedIn', false);
  }

  static Future<List<DocumentSnapshot>> fetchAllUserData(
      String currentUserEmail) async {
    try {
      final usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return usersSnapshot.docs
          .where((doc) => doc['email'] != currentUserEmail)
          .toList();
    } catch (e) {
      _logger.e('Error fetching user data: $e');
      rethrow;
    }
  }

  static Future<List<DocumentSnapshot>> fetchUserData(String email) async {
    try {
      final userData =
          await FirebaseFirestore.instance.collection('users').get();
      return userData.docs.where((doc) => doc['email'] == email).toList();
    } catch (e) {
      _logger.e('Error fetching user data: $e');
      rethrow;
    }
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
