import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/model/user_model.dart';
import 'package:quick_chat/module/views/chat/chat_screen.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';

class UserDataListWidget extends StatefulWidget {
  final String currentUserEmail;

  const UserDataListWidget({Key? key, required this.currentUserEmail})
      : super(key: key);

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
    return FutureBuilder<List<UserData>>(
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
              final userData = userList[index];
              final chatRoomId = FirebaseHelper.getChatRoomId(
                  widget.currentUserEmail, userData.email);
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverUser: userData,
                        receiverUsername: userData.username,
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
                        child: CircleAvatar(
                          backgroundColor: AppTheme.backgroundColor,
                          backgroundImage: userData.imageUrl.isNotEmpty
                              ? NetworkImage(userData.imageUrl)
                              : const AssetImage('assets/img/users/unu.png')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.username,
                            style: AppTheme.titleMedium
                                .copyWith(color: AppTheme.textColor),
                          ),
                          Text(
                            userData.email,
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
// import 'package:quick_chat/model/user_model.dart';
// import 'package:quick_chat/module/views/chat/chat_screen.dart';
// import 'package:quick_chat/module/views/themes/app_theme.dart';
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
//               color: AppTheme.textColor,
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else {
//           final userList = snapshot.data!;
//           return ListView.builder(
//             itemCount: userList.length,
//             itemBuilder: (context, index) {
//               final UserData userData = userList[index].data() as UserData;
//               // final username = userData['username'] ?? 'Unknown';
//               // final email = userData['email'] ?? 'Unknown';
//               // final imageUrl = userData['imageUrl'] ?? '';
//               final chatRoomId = FirebaseHelper.getChatRoomId(
//                   widget.currentUserEmail, userData.email);
//               return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatScreen(
//                         receiverUsername: userData.username,
//                         currentUserEmail: widget.currentUserEmail,
//                         chatRoomId: chatRoomId,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.all(10),
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 10,
//                     horizontal: 20,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                     boxShadow: [
//                       const BoxShadow(
//                           color: Colors.blueAccent,
//                           blurRadius: 15,
//                           blurStyle: BlurStyle.outer),
//                       BoxShadow(
//                           color: Colors.pinkAccent.withOpacity(0.3),
//                           blurRadius: 1,
//                           blurStyle: BlurStyle.normal),
//                     ],
//                     color: AppTheme.backgroundColor.withOpacity(0.5),
//                   ),
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
//                         child: CircleAvatar(
//                           backgroundColor: AppTheme.backgroundColor,
//                           backgroundImage: userData.imageUrl.isNotEmpty
//                               ? NetworkImage(userData.imageUrl)
//                               : const AssetImage('assets/img/users/unu.png')
//                                   as ImageProvider,
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             userData.username,
//                             style: AppTheme.titleMedium
//                                 .copyWith(color: AppTheme.textColor),
//                           ),
//                           Text(
//                             userData.email,
//                             style: AppTheme.bodyMedium
//                                 .copyWith(color: AppTheme.textColor),
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       const Icon(Icons.chevron_right,
//                           color: AppTheme.textColor),
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
