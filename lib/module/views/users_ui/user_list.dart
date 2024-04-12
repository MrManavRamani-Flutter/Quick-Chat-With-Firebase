import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final String username;

  const ProfileAvatar({
    Key? key,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.0),
        color: Colors.blueAccent.withOpacity(0.3),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            child: Image(image: AssetImage(imageUrl)),
          ),
          const SizedBox(width: 15.0),
          Text(
            username,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
