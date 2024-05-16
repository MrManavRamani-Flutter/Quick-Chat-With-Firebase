import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/model/user_model.dart';
import 'package:quick_chat/module/views/profile/profile_screen.dart';
import 'package:quick_chat/module/views/profile/widgets/profile_setup_form.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String email;

  const ProfileSetupScreen({super.key, required this.email});

  @override
  ProfileSetupScreenState createState() => ProfileSetupScreenState();
}

class ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  File? _image;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Fetch user data from Firestore
      UserData userData = await FirebaseHelper.getUserData(widget.email);

      // Populate the TextFields and the profile image if data exists
      setState(() {
        _usernameController.text = userData.username;
        _bioController.text = userData.bio;
        if (userData.imageUrl.isNotEmpty) {
          _image = File(userData.imageUrl);
        }
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    String username = _usernameController.text.trim();
    String bio = _bioController.text.trim();

    // Upload profile image
    String imageUrl = '';
    if (_image != null) {
      imageUrl = (await FirebaseHelper.uploadProfileImage(_image!))!;
    }

    // Set profile data
    await FirebaseHelper.setProfile(
      username,
      widget.email,
      bio,
      imageUrl,
    );

    setState(() {
      _isSaving = false;
    });

    // Check if the user is already logged in
    if (await FirebaseHelper.isLoggedIn()) {
      // If logged in, navigate to the profile screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            currentUserEmail: widget.email,
          ),
        ),
      );
    } else {
      // If not logged in, navigate to the login screen
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ProfileSetupForm(
          usernameController: _usernameController,
          bioController: _bioController,
          image: _image,
          isSaving: _isSaving,
          getImage: _getImage,
          saveProfile: _saveProfile,
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:quick_chat/helpers/firebase_helper.dart';
// import 'package:quick_chat/model/user_model.dart';
// import 'package:quick_chat/module/views/profile/profile_screen.dart';
//
// class ProfileSetupScreen extends StatefulWidget {
//   final String email;
//
//   const ProfileSetupScreen({super.key, required this.email});
//
//   @override
//   ProfileSetupScreenState createState() => ProfileSetupScreenState();
// }
//
// class ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _bioController = TextEditingController();
//   File? _image;
//   bool _isSaving = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     try {
//       // Fetch user data from Firestore
//       UserData userData = await FirebaseHelper.getUserData(widget.email);
//
//       // Populate the TextFields and the profile image if data exists
//       setState(() {
//         _usernameController.text = userData.username;
//         _bioController.text = userData.bio;
//         if (userData.imageUrl.isNotEmpty) {
//           _image = File(userData.imageUrl);
//         }
//       });
//     } catch (e) {
//       print('Error loading user data: $e');
//     }
//   }
//
//   Future<void> _getImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       _image = File(pickedFile!.path);
//     });
//   }
//
//   Future<void> _saveProfile() async {
//     setState(() {
//       _isSaving = true;
//     });
//
//     String username = _usernameController.text.trim();
//     String bio = _bioController.text.trim();
//
//     // Upload profile image
//     String imageUrl = '';
//     if (_image != null) {
//       imageUrl = (await FirebaseHelper.uploadProfileImage(_image!))!;
//     }
//
//     // Set profile data
//     await FirebaseHelper.setProfile(
//       username,
//       widget.email,
//       bio,
//       imageUrl,
//     );
//
//     setState(() {
//       _isSaving = false;
//     });
//
//     // Check if the user is already logged in
//     if (await FirebaseHelper.isLoggedIn()) {
//       // If logged in, navigate to the profile screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ProfileScreen(
//             currentUserEmail: widget.email,
//           ),
//         ),
//       );
//     } else {
//       // If not logged in, navigate to the login screen
//       Navigator.pushReplacementNamed(context, 'login');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile Setup'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _image != null
//                 ? CircleAvatar(
//                     radius: 70,
//                     backgroundColor: Colors.blueGrey,
//                     child: ClipOval(
//                       child: Image.file(
//                         _image!,
//                         fit: BoxFit.cover,
//                         width: 140,
//                         height: 140,
//                       ),
//                     ),
//                   )
//                 : GestureDetector(
//                     onTap: _getImage,
//                     child: const CircleAvatar(
//                       radius: 70,
//                       backgroundColor: Colors.blueGrey,
//                       child: Icon(
//                         Icons.add_a_photo,
//                         color: Colors.white,
//                         size: 80,
//                       ),
//                     ),
//                   ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _usernameController,
//               decoration: const InputDecoration(
//                 hintText: 'Username',
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _bioController,
//               decoration: const InputDecoration(
//                 hintText: 'Bio',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isSaving ? null : _saveProfile,
//               child: _isSaving
//                   ? const CircularProgressIndicator()
//                   : const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
