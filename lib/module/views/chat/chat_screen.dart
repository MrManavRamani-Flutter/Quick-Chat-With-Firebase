import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String username;
  const ChatScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(username)),
    );
  }
}
