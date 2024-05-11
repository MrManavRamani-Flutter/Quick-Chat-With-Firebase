import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';
import 'send_image_screen.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserEmail;
  final String chatRoomId;

  const ChatScreen({
    Key? key,
    required this.currentUserEmail,
    required this.chatRoomId,
  }) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages'));
                } else {
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> messageData =
                          messages[index].data() as Map<String, dynamic>;
                      final String sender = messageData['sender'] as String;
                      final String? imageUrl =
                          messageData['imageUrl'] as String?;
                      final String? message = messageData['message'] as String?;
                      final DateTime time =
                          (messageData['time'] as Timestamp).toDate();
                      final isMe = sender == widget.currentUserEmail;
                      return MessageBubble(
                        message: message,
                        imageUrl: imageUrl,
                        isMe: isMe,
                        time: time,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            color: Colors.grey[200],
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendImageScreen(
                          currentUserEmail: widget.currentUserEmail,
                          chatRoomId: widget.chatRoomId,
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    String message = _messageController.text.trim();
    _messageController.clear(); // Clear TextField
    if (message.isEmpty) {
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'message': message,
        'sender': widget.currentUserEmail,
        'time': Timestamp.now(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
