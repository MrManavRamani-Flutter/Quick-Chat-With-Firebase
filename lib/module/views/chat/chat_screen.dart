import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/model/user_model.dart';
import 'package:quick_chat/module/views/profile/user_profile_screen.dart';

import 'message_bubble.dart';
import 'send_image_screen.dart';

class ChatScreen extends StatefulWidget {
  final UserData receiverUser;
  final String currentUserEmail;
  final String receiverUsername;
  final String chatRoomId;

  const ChatScreen({
    super.key,
    required this.currentUserEmail,
    required this.chatRoomId,
    required this.receiverUsername,
    required this.receiverUser,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final Set<DocumentSnapshot> _selectedMessages = {};
  bool _isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUsername),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserProfileScreen(user: widget.receiverUser),
                ),
              );
            },
            icon: const Icon(Icons.person_pin_rounded),
          ),
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedMessages,
            ),
        ],
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
                      final messageDoc = messages[index];
                      final Map<String, dynamic> messageData =
                          messageDoc.data() as Map<String, dynamic>;
                      final String sender = messageData['sender'] as String;
                      final String? imageUrl =
                          messageData['imageUrl'] as String?;
                      final String? message = messageData['message'] as String?;
                      final DateTime time =
                          (messageData['time'] as Timestamp).toDate();
                      final isMe = sender == widget.currentUserEmail;
                      final isSelected = _selectedMessages.contains(messageDoc);

                      return GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _isSelectionMode = true;
                            if (isSelected) {
                              _selectedMessages.remove(messageDoc);
                            } else {
                              _selectedMessages.add(messageDoc);
                            }
                          });
                        },
                        child: MessageBubble(
                          message: message,
                          imageUrl: imageUrl,
                          isMe: isMe,
                          time: time,
                          isSelected: isSelected,
                          showCheckbox: _isSelectionMode,
                          onCheckboxChanged: (bool? checked) {
                            setState(() {
                              if (checked ?? false) {
                                _selectedMessages.add(messageDoc);
                              } else {
                                _selectedMessages.remove(messageDoc);
                              }
                              if (_selectedMessages.isEmpty) {
                                _isSelectionMode = false;
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
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

  Future<void> _deleteSelectedMessages() async {
    for (var messageDoc in _selectedMessages) {
      try {
        final messageData = messageDoc.data() as Map<String, dynamic>;
        final imageUrl = messageData['imageUrl'] as String?;

        if (imageUrl != null) {
          final ref = FirebaseStorage.instance.refFromURL(imageUrl);
          await ref.delete();
        }

        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatRoomId)
            .collection('messages')
            .doc(messageDoc.id)
            .delete();
      } catch (e) {
        print('Error deleting message: $e');
      }
    }

    setState(() {
      _selectedMessages.clear();
      _isSelectionMode = false;
    });
  }
}
