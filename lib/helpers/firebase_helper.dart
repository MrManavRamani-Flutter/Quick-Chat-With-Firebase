import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quick_chat/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHelper {
  //fetch User Post Count
  static Future<int> getPostCount(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('email', isEqualTo: email)
              .get();
      return querySnapshot.size;
    } catch (e) {
      throw Exception('Failed to fetch post count: $e');
    }
  }

  //fetch User Posts
  static Stream<QuerySnapshot<Map<String, dynamic>>> userPostsStream(
      String email) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('email', isEqualTo: email)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  //fetch User Posts by email
  static Stream<List<Map<String, dynamic>>> fetchUserPostsByEmail1(
      String email) {
    try {
      return FirebaseFirestore.instance
          .collection('posts')
          .where('email', isEqualTo: email)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUserPostsByEmail(
      String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('email', isEqualTo: email)
              .orderBy('timestamp', descending: true)
              .get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  // Upload User Post
  static Future<void> uploadUserPost({
    required String email,
    required File imageFile,
  }) async {
    try {
      String filePath =
          'posts/${email}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      TaskSnapshot uploadTask =
          await FirebaseStorage.instance.ref(filePath).putFile(imageFile);
      String downloadURL = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('posts').add({
        'email': email,
        'imageURL': downloadURL,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }

  // Search User
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
          email: userData['email'] ?? '',
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

  // Fetch User By Email
  static Future<UserData> getUserData(String email) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (userDataSnapshot.exists) {
        Map<String, dynamic> userDataMap = userDataSnapshot.data()!;
        return UserData(
          email: userDataMap['email'] ?? '',
          username: userDataMap['username'] ?? '',
          bio: userDataMap['bio'] ?? '',
          imageUrl: userDataMap['imageUrl'] ?? '',
        );
      } else {
        return UserData(
          email: '',
          username: '',
          bio: '',
          imageUrl: '',
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return UserData(
        email: '',
        username: '',
        bio: '',
        imageUrl: '',
      );
    }
  }

  // Update User Profile
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

  //set Profile After SignUp
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

  //Create ChatRoomID
  static String getChatRoomId(String user1Email, String user2Email) {
    List<String> users = [user1Email, user2Email];
    users.sort();
    return '${users[0]}_${users[1]}';
  }

  //Login User and also Set In local sqlite data like email for already login user
  static Future<bool> loginUser(String email, String password) async {
    try {
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

  // current user logout and also clear data in local sqlite storage
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

  //New user signUp
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

  //Save data in local sqlite storage
  static Future<void> _saveUserDataToSharedPreferences(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setBool('isLoggedIn', true);
  }

  // clear data in local sqlite storage
  static Future<void> _clearUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.setBool('isLoggedIn', false);
  }

  // fetch all user data
  static Future<List<UserData>> fetchAllUserData(
      String currentUserEmail) async {
    try {
      final usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return usersSnapshot.docs
          .where((doc) => doc['email'] != currentUserEmail)
          .map((doc) => UserData(
                email: doc['email'] ?? '',
                username: doc['username'] ?? '',
                bio: doc['bio'] ?? '',
                imageUrl: doc['imageUrl'] ?? '',
              ))
          .toList();
    } catch (e) {
      _logger.e('Error fetching user data: $e');
      rethrow;
    }
  }

  //fetch user data based on email
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

  //check user login or not
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
