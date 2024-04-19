import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHelper {
  static Future<bool> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserDataToSharedPreferences(email);

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await _clearUserDataFromSharedPreferences();
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    } catch (e) {
      print('Error logging out: $e');
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
      print('Signup error: $e');
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
}
