import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/module/views/profile/profile_setup_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.lightBlueAccent],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person_add, size: 60.0, color: Colors.white),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.05),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: () async {
                    String username = usernameController.text.trim();
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    try {
                      await FirebaseHelper.signUpUser(
                          username, email, password);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signup successful')),
                        );
                      }
                      emailController.clear();
                      passwordController.clear();
                      usernameController.clear();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileSetupScreen(email: email),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Signup failed. Please try again.')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: screenWidth * 0.045, color: Colors.white),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'login');
                  },
                  child: Text(
                    'Already have an account? Log in',
                    style: TextStyle(
                        color: Colors.white, fontSize: screenWidth * 0.04),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:quick_chat/helpers/firebase_helper.dart';
// import 'package:quick_chat/module/views/profile/profile_setup_screen.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(20.0),
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.black, Colors.lightBlueAccent],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Icon(Icons.person_add, size: 60.0, color: Colors.white),
//             const SizedBox(height: 20.0),
//             const Text(
//               'Sign Up',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 32.0,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20.0),
//             TextFormField(
//               controller: usernameController,
//               decoration: InputDecoration(
//                 hintText: 'Enter your name',
//                 hintStyle: const TextStyle(color: Colors.white70),
//                 prefixIcon: const Icon(Icons.person, color: Colors.white),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.1),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: const BorderSide(color: Colors.white),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: const BorderSide(color: Colors.white),
//                 ),
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//             const SizedBox(height: 10.0),
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 hintText: 'Enter your email',
//                 hintStyle: const TextStyle(color: Colors.white70),
//                 prefixIcon: const Icon(Icons.email, color: Colors.white),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.1),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: const BorderSide(color: Colors.white),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: const BorderSide(color: Colors.white),
//                 ),
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//             const SizedBox(height: 10.0),
//             TextFormField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Enter your password',
//                 hintStyle: const TextStyle(color: Colors.white70),
//                 prefixIcon: const Icon(Icons.lock, color: Colors.white),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.1),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: const BorderSide(color: Colors.white),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: const BorderSide(color: Colors.white),
//                 ),
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//             const SizedBox(height: 20.0),
//             // Sign Up button ................
//             ElevatedButton(
//               onPressed: () async {
//                 String username = usernameController.text.trim();
//                 String email = emailController.text.trim();
//                 String password = passwordController.text.trim();
//
//                 try {
//                   await FirebaseHelper.signUpUser(username, email, password);
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Signup successful')),
//                     );
//                   }
//                   emailController.clear();
//                   passwordController.clear();
//                   usernameController.clear();
//                   if (context.mounted) {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProfileSetupScreen(email: email),
//                       ),
//                     );
//                   }
//                 } catch (e) {
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Signup failed. Please try again.')),
//                     );
//                   }
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 padding: const EdgeInsets.symmetric(vertical: 12.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//               ),
//               child: const Text(
//                 'Sign Up',
//                 style: TextStyle(fontSize: 18.0, color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, 'login');
//               },
//               child: const Text(
//                 'Already have an account? Log in',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
