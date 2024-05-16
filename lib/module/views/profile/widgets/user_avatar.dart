import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;

  const UserAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 1),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.fill,
          ),
        ),
        height: 200,
        width: 200,
        child: imageUrl.isEmpty
            ? const Icon(Icons.person, size: 40, color: Colors.white)
            : null,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class UserAvatar extends StatelessWidget {
//   final String imageUrl;
//
//   const UserAvatar({super.key, required this.imageUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         gradient: const LinearGradient(
//           colors: [Color(0xFFFD297B), Color(0xFFFF5864)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       padding: const EdgeInsets.all(8),
//       child: imageUrl.isNotEmpty
//           ? CircleAvatar(
//               backgroundImage: NetworkImage(imageUrl),
//               radius: 50,
//             )
//           : const CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 50,
//               child: Icon(Icons.person, size: 50),
//             ),
//     );
//   }
// }
