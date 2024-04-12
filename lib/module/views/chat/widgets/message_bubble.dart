import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool isSentByMe;
  final String message;

  const MessageBubble({
    Key? key,
    required this.isSentByMe,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSentByMe
                ? Colors.blueAccent.shade700.withRed(10)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: isSentByMe ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                "5:30 PM",
                style: TextStyle(
                  color: isSentByMe ? Colors.white70 : Colors.black54,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
