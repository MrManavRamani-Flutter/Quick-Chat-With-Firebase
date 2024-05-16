// home_screen.dart
import 'package:flutter/material.dart';
import 'package:quick_chat/module/views/screens/list_user_ui/list_user.dart';
import 'package:quick_chat/module/views/themes/app_theme.dart';
import 'package:quick_chat/module/views/widgets/bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  final String currentUserEmail;
  const HomeScreen({super.key, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: const Text(
          'Quick Chat',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: AppTheme.gradientBackground,
          color: Colors.teal.withOpacity(0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: UserDataListWidget(currentUserEmail: currentUserEmail),
        ),
      ),
      bottomNavigationBar: BottomNavigation(currentUserEmail: currentUserEmail),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:quick_chat/module/views/screens/list_user_ui/list_user.dart';
// import 'package:quick_chat/module/views/search_user/search_users.dart';
// import 'package:quick_chat/module/views/themes/app_theme.dart';
//
// class HomeScreen extends StatelessWidget {
//   final String currentUserEmail;
//   const HomeScreen({super.key, required this.currentUserEmail});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppTheme.backgroundColor,
//         title: const Text(
//           'Quick Chat',
//           style: TextStyle(
//             color: AppTheme.textColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(10.0),
//         decoration: BoxDecoration(
//           gradient: AppTheme.gradientBackground,
//           color: Colors.teal.withOpacity(0.5),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: UserDataListWidget(currentUserEmail: currentUserEmail),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: AppTheme.backgroundColor,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.home, color: AppTheme.textColor),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: const Icon(Icons.search, color: AppTheme.textColor),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         SearchScreen(currentUserEmail: currentUserEmail),
//                   ),
//                 );
//               },
//             ),
//             IconButton(
//               icon: const Icon(
//                 Icons.add_reaction_outlined,
//                 color: Colors.grey,
//               ),
//               onPressed: () {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) =>
//                 //         AddFriend(currentUserEmail: currentUserEmail),
//                 //   ),
//                 // );
//               },
//             ),
//             IconButton(
//               icon: const Icon(
//                 Icons.favorite_border,
//                 color: Colors.grey,
//               ),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: const Icon(Icons.settings, color: AppTheme.textColor),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/settings');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
