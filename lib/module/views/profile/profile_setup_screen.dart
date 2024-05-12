import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/model/user_model.dart';
import 'package:quick_chat/module/views/profile/profile_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String email;

  const ProfileSetupScreen({Key? key, required this.email}) : super(key: key);

  @override
  ProfileSetupScreenState createState() => ProfileSetupScreenState();
}

class ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  File? _image;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.blueGrey,
                    child: ClipOval(
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                        width: 140,
                        height: 140,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: _getImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blueGrey,
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Username',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                hintText: 'Bio',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text.trim();
                String bio = _bioController.text.trim();

                // Upload profile image
                String imageUrl = '';
                if (_image != null) {
                  imageUrl =
                      (await FirebaseHelper.uploadProfileImage(_image!))!;
                }

                // Set profile data
                await FirebaseHelper.setProfile(
                  username,
                  widget.email,
                  bio,
                  imageUrl,
                );

                // Check if the user is already logged in
                if (await FirebaseHelper.isLoggedIn()) {
                  // If logged in, navigate to the profile screen
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          currentUserEmail: widget.email,
                        ),
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Profile Setup successful, Login to view your profile!')),
                    );
                  }
                  // If not logged in, navigate to the login screen
                  Navigator.pushReplacementNamed(context, 'login');
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:quick_chat/helpers/firebase_helper.dart';
// import 'package:quick_chat/model/user_model.dart';
//
// class ProfileSetupScreen extends StatefulWidget {
//   final String email;
//
//   const ProfileSetupScreen({Key? key, required this.email}) : super(key: key);
//
//   @override
//   ProfileSetupScreenState createState() => ProfileSetupScreenState();
// }
//
// class ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _bioController = TextEditingController();
//   File? _image;
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
//                 ? Image.file(
//                     _image!,
//                     height: 200,
//                     width: 200,
//                     fit: BoxFit.cover,
//                   )
//                 : GestureDetector(
//                     onTap: _getImage,
//                     child: Container(
//                       height: 200,
//                       width: 200,
//                       color: Colors.grey,
//                       child: const Icon(
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
//               onPressed: () async {
//                 String username = _usernameController.text.trim();
//                 String bio = _bioController.text.trim();
//
//                 // Upload profile image
//                 String imageUrl = '';
//                 if (_image != null) {
//                   imageUrl =
//                       (await FirebaseHelper.uploadProfileImage(_image!))!;
//                 }
//
//                 // Set profile data
//                 await FirebaseHelper.setProfile(
//                   username,
//                   widget.email,
//                   bio,
//                   imageUrl,
//                 );
//
//                 // Check if the user is already logged in
//                 if (await FirebaseHelper.isLoggedIn()) {
//                   // If logged in, navigate to the profile screen
//                   Navigator.pushReplacementNamed(context, 'profile');
//                 } else {
//                   // If not logged in, navigate to the login screen
//                   Navigator.pushReplacementNamed(context, 'login');
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//-------------------------------

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:quick_chat/helpers/firebase_helper.dart';
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
//                 ? Image.file(
//                     _image!,
//                     height: 200,
//                     width: 200,
//                     fit: BoxFit.cover,
//                   )
//                 : GestureDetector(
//                     onTap: _getImage,
//                     child: Container(
//                       height: 200,
//                       width: 200,
//                       color: Colors.grey,
//                       child: const Icon(
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
//               onPressed: () async {
//                 String username = _usernameController.text.trim();
//                 String bio = _bioController.text.trim();
//
//                 // Upload profile image
//                 String imageUrl = '';
//                 if (_image != null) {
//                   imageUrl =
//                       (await FirebaseHelper.uploadProfileImage(_image!))!;
//                 }
//
//                 // Set profile data
//                 await FirebaseHelper.setProfile(
//                   username,
//                   widget.email,
//                   bio,
//                   imageUrl,
//                 );
//
//                 // Check if the user is already logged in
//                 if (await FirebaseHelper.isLoggedIn()) {
//                   // If logged in, navigate to the profile screen
//                   Navigator.pushReplacementNamed(context, 'profile');
//                 } else {
//                   // If not logged in, navigate to the login screen
//                   Navigator.pushReplacementNamed(context, 'login');
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
