import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'image_preview_screen.dart';

class MessageBubble extends StatelessWidget {
  final String? message;
  final String? imageUrl;
  final bool isMe;
  final DateTime time;

  const MessageBubble({
    Key? key,
    this.message,
    this.imageUrl,
    required this.isMe,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('hh:mm a');
    final formattedTime = timeFormat.format(time);

    return Container(
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: isMe ? 60 : 10,
        right: isMe ? 10 : 60,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft:
                    isMe ? const Radius.circular(20) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImagePreviewScreen(
                            imageUrl: imageUrl!,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl!,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const CircularProgressIndicator(
                              color: Colors.blue,
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Text('Failed to load image');
                        },
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (message != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    message!,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: isMe ? Colors.white : Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
