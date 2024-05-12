import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/module/views/chat/chat_screen.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';

class UserDataListWidget extends StatefulWidget {
  final String currentUserEmail;

  const UserDataListWidget({super.key, required this.currentUserEmail});

  @override
  State<UserDataListWidget> createState() => _UserDataListWidgetState();
}

class _UserDataListWidgetState extends State<UserDataListWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: FirebaseHelper.fetchAllUserData(widget.currentUserEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.textColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userList = snapshot.data!;
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final userData = userList[index].data() as Map<String, dynamic>;
              final username = userData['username'] ?? 'Unknown';
              final email = userData['email'] ?? 'Unknown';
              final chatRoomId =
                  FirebaseHelper.getChatRoomId(widget.currentUserEmail, email);
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverUsername: username,
                        currentUserEmail: widget.currentUserEmail,
                        chatRoomId: chatRoomId,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.blueAccent,
                          blurRadius: 15,
                          blurStyle: BlurStyle.outer),
                      BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.3),
                          blurRadius: 1,
                          blurStyle: BlurStyle.normal),
                    ],
                    color: AppTheme.backgroundColor.withOpacity(0.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutBack,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: AppTheme.backgroundColor,
                          child: FlutterLogo(size: 40),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: AppTheme.titleMedium
                                .copyWith(color: AppTheme.textColor),
                          ),
                          Text(
                            email,
                            style: AppTheme.bodyMedium
                                .copyWith(color: AppTheme.textColor),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right,
                          color: AppTheme.textColor),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:quick_chat/helpers/firebase_helper.dart';
// import 'package:quick_chat/module/views/chat/chat_screen.dart';
//
// class UserDataListWidget extends StatefulWidget {
//   final String currentUserEmail;
//
//   const UserDataListWidget({super.key, required this.currentUserEmail});
//
//   @override
//   State<UserDataListWidget> createState() => _UserDataListWidgetState();
// }
//
// class _UserDataListWidgetState extends State<UserDataListWidget>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<DocumentSnapshot>>(
//       future: FirebaseHelper.fetchAllUserData(widget.currentUserEmail),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: Colors.purple,
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else {
//           final userList = snapshot.data!;
//           return ListView.builder(
//             itemCount: userList.length,
//             itemBuilder: (context, index) {
//               final userData = userList[index].data() as Map<String, dynamic>;
//               final username = userData['username'] ?? 'Unknown';
//               final email = userData['email'] ?? 'Unknown';
//               final chatRoomId =
//                   FirebaseHelper.getChatRoomId(widget.currentUserEmail, email);
//               return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatScreen(
//                         receiverUsername: username,
//                         currentUserEmail: widget.currentUserEmail,
//                         chatRoomId: chatRoomId,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ScaleTransition(
//                         scale: Tween<double>(begin: 0, end: 1).animate(
//                           CurvedAnimation(
//                             parent: _animationController,
//                             curve: Curves.easeOutBack,
//                           ),
//                         ),
//                         child: const CircleAvatar(
//                           backgroundColor: Colors.purple,
//                           child: FlutterLogo(size: 40),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             username,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.purple,
//                             ),
//                           ),
//                           Text(
//                             email,
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       const Icon(Icons.chevron_right, color: Colors.purple),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:quick_chat/helpers/firebase_helper.dart';
// import 'package:quick_chat/module/views/chat/chat_screen.dart';
//
// class UserDataListWidget extends StatelessWidget {
//   final String currentUserEmail;
//
//   const UserDataListWidget({super.key, required this.currentUserEmail});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<DocumentSnapshot>>(
//       future: FirebaseHelper.fetchAllUserData(currentUserEmail),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else {
//           final userList = snapshot.data!;
//           return ListView.builder(
//             itemCount: userList.length,
//             itemBuilder: (context, index) {
//               final userData = userList[index].data() as Map<String, dynamic>;
//               final username = userData['username'] ?? 'Unknown';
//               final email = userData['email'] ?? 'Unknown';
//               final chatRoomId =
//                   FirebaseHelper.getChatRoomId(currentUserEmail, email);
//               return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatScreen(
//                         receiverUsername: username,
//                         currentUserEmail: currentUserEmail,
//                         chatRoomId: chatRoomId,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: Colors.grey[300],
//                         child: const FlutterLogo(size: 40),
//                       ),
//                       const SizedBox(width: 20),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             username,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             email,
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       const Icon(Icons.chevron_right),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
//
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:quick_chat/helpers/firebase_helper.dart';
// // import 'package:quick_chat/module/views/chat/chat_screen.dart';
// //
// // class UserDataListWidget extends StatelessWidget {
// //   final String currentUserEmail;
// //
// //   const UserDataListWidget({Key? key, required this.currentUserEmail})
// //       : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder<List<DocumentSnapshot>>(
// //       future: FirebaseHelper.fetchAllUserData(currentUserEmail),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return const Center(child: CircularProgressIndicator());
// //         } else if (snapshot.hasError) {
// //           return Center(child: Text('Error: ${snapshot.error}'));
// //         } else {
// //           final userList = snapshot.data!;
// //           return ListView.builder(
// //             itemCount: userList.length,
// //             itemBuilder: (context, index) {
// //               final userData = userList[index].data() as Map<String, dynamic>;
// //               final username = userData['username'] ?? 'Unknown';
// //               final email = userData['email'] ?? 'Unknown';
// //               final chatRoomId =
// //                   FirebaseHelper.getChatRoomId(currentUserEmail, email);
// //               return ListTile(
// //                 title: Text(username),
// //                 subtitle: Text(email),
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => ChatScreen(
// //                         receiverUsername: username,
// //                         currentUserEmail: currentUserEmail,
// //                         chatRoomId: chatRoomId,
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               );
// //             },
// //           );
// //         }
// //       },
// //     );
// //   }
// // }
