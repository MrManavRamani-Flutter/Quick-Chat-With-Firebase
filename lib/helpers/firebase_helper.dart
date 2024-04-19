import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHelper {
  static final Logger _logger = Logger();
  static Future<bool> loginUser(String email, String password) async {
    try {
      // UserCredential userCredential =
      //     await FirebaseAuth.instance.signInWithEmailAndPassword(
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

  static Future<String?> getCurrentUserId() async {
    try {
      // Get the current user from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Return the user's ID if it exists
        return user.uid;
      } else {
        // Return null if no user is logged in
        return null;
      }
    } catch (e) {
      _logger.e('Error getting current user ID: $e');
      return null;
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
}
