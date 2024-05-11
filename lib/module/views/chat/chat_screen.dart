import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;

  bool _isImageSelected = false;

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
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: _isImageSelected
                      ? const SizedBox.shrink()
                      : TextField(
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final imageUrl = await _uploadImageToFirestore(imageFile);
      setState(() {
        _uploadedImageUrl = imageUrl;
        _isImageSelected = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(
            imageUrl: imageUrl,
            sendMessage: _sendMessage,
          ),
        ),
      );
    }
  }

  Future<String> _uploadImageToFirestore(File imageFile) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() {});
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> _sendMessage() async {
    String message = _messageController.text.trim();
    _messageController.clear(); // Clear TextField
    if (message.isEmpty && _uploadedImageUrl == null) {
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
        'imageUrl': _uploadedImageUrl,
        'time': Timestamp.now(),
      });
      setState(() {
        _uploadedImageUrl = null;
        _isImageSelected = false;
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}

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

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
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
                        sendMessage: () {}, // Placeholder for send function
                      ),
                    ),
                  );
                },
                child: Image.network(
                  imageUrl!,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const CircularProgressIndicator();
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
            if (message != null) ...[
              Text(
                message!,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
            ],
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
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;
  final Function sendMessage;

  const ImagePreviewScreen({
    Key? key,
    required this.imageUrl,
    required this.sendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(
          imageUrl,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const CircularProgressIndicator();
            }
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Text('Failed to load image');
          },
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await sendMessage(); // Call the sendMessage function
          Navigator.pop(context);
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String currentUserEmail;
//   final String chatRoomId;
//
//   const ChatScreen({
//     Key? key,
//     required this.currentUserEmail,
//     required this.chatRoomId,
//   }) : super(key: key);
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   String? _uploadedImageUrl;
//
//   bool _isImageSelected = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(widget.chatRoomId)
//                   .collection('messages')
//                   .orderBy('time', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No messages'));
//                 } else {
//                   final messages = snapshot.data!.docs;
//                   return ListView.builder(
//                     reverse: true,
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       final Map<String, dynamic> messageData =
//                           messages[index].data() as Map<String, dynamic>;
//                       final String sender = messageData['sender'] as String;
//                       final String? imageUrl =
//                           messageData['imageUrl'] as String?;
//                       final String? message = messageData['message'] as String?;
//                       final DateTime time =
//                           (messageData['time'] as Timestamp).toDate();
//                       final isMe = sender == widget.currentUserEmail;
//                       return MessageBubble(
//                         message: message,
//                         imageUrl: imageUrl,
//                         isMe: isMe,
//                         time: time,
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//             color: Colors.grey[200],
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.attach_file),
//                   onPressed: _pickImage,
//                 ),
//                 Expanded(
//                   child: _isImageSelected
//                       ? const SizedBox.shrink()
//                       : TextField(
//                           controller: _messageController,
//                           decoration: const InputDecoration(
//                             hintText: 'Type a message...',
//                             border: InputBorder.none,
//                           ),
//                         ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed:
//                       _messageController.text.isEmpty ? null : _sendMessage,
//                 ),
//
//                 // IconButton(
//                 //   icon: const Icon(Icons.send),
//                 //   onPressed: _sendMessage,
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final imageFile = File(pickedFile.path);
//       final imageUrl = await _uploadImageToFirestore(imageFile);
//       setState(() {
//         _uploadedImageUrl = imageUrl;
//         _isImageSelected = true;
//       });
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ImagePreviewScreen(imageUrl: imageUrl),
//         ),
//       );
//     }
//   }
//
//   Future<String> _uploadImageToFirestore(File imageFile) async {
//     try {
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('chat_images')
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
//       final uploadTask = ref.putFile(imageFile);
//       await uploadTask.whenComplete(() {});
//       return await ref.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return '';
//     }
//   }
//
//   Future<void> _sendMessage() async {
//     String message = _messageController.text.trim();
//     _messageController.clear(); // Clear TextField
//     if (message.isEmpty && _uploadedImageUrl == null) {
//       return;
//     }
//     try {
//       await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(widget.chatRoomId)
//           .collection('messages')
//           .add({
//         'message': message,
//         'sender': widget.currentUserEmail,
//         'imageUrl': _uploadedImageUrl, // Include imageUrl if available
//         'time': Timestamp.now(),
//       });
//       setState(() {
//         _uploadedImageUrl = null;
//         _isImageSelected = false;
//       });
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }
//
// // Future<void> _sendMessage() async {
//   //   String message = _messageController.text.trim();
//   //   _messageController.clear(); // Clear TextField
//   //   if (message.isEmpty && _uploadedImageUrl == null) {
//   //     return;
//   //   }
//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection('chats')
//   //         .doc(widget.chatRoomId)
//   //         .collection('messages')
//   //         .add({
//   //       'message': message,
//   //       'sender': widget.currentUserEmail,
//   //       'imageUrl': _uploadedImageUrl,
//   //       'time': Timestamp.now(),
//   //     });
//   //     setState(() {
//   //       _uploadedImageUrl = null;
//   //       _isImageSelected = false;
//   //     });
//   //   } catch (e) {
//   //     print('Error sending message: $e');
//   //   }
//   // }
// }
//
// class MessageBubble extends StatelessWidget {
//   final String? message;
//   final String? imageUrl;
//   final bool isMe;
//   final DateTime time;
//
//   const MessageBubble({
//     Key? key,
//     this.message,
//     this.imageUrl,
//     required this.isMe,
//     required this.time,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final timeFormat = DateFormat('hh:mm a');
//     final formattedTime = timeFormat.format(time);
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blue : Colors.grey[300],
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(20),
//             topRight: const Radius.circular(20),
//             bottomLeft:
//                 isMe ? const Radius.circular(20) : const Radius.circular(0),
//             bottomRight:
//                 isMe ? const Radius.circular(0) : const Radius.circular(20),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (imageUrl != null)
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           ImagePreviewScreen(imageUrl: imageUrl!),
//                     ),
//                   );
//                 },
//                 child: Image.network(
//                   imageUrl!,
//                   loadingBuilder: (BuildContext context, Widget child,
//                       ImageChunkEvent? loadingProgress) {
//                     if (loadingProgress == null) {
//                       return child;
//                     } else {
//                       return const CircularProgressIndicator();
//                     }
//                   },
//                   errorBuilder: (BuildContext context, Object exception,
//                       StackTrace? stackTrace) {
//                     return const Text('Failed to load image');
//                   },
//                   width: 150,
//                   height: 150,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             if (message != null) ...[
//               Text(
//                 message!,
//                 style: TextStyle(
//                   color: isMe ? Colors.white : Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 4),
//             ],
//             Text(
//               formattedTime,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: isMe ? Colors.white : Colors.black.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ImagePreviewScreen extends StatelessWidget {
//   final String imageUrl;
//
//   const ImagePreviewScreen({Key? key, required this.imageUrl})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Image.network(
//           imageUrl,
//           loadingBuilder: (BuildContext context, Widget child,
//               ImageChunkEvent? loadingProgress) {
//             if (loadingProgress == null) {
//               return child;
//             } else {
//               return const CircularProgressIndicator();
//             }
//           },
//           errorBuilder:
//               (BuildContext context, Object exception, StackTrace? stackTrace) {
//             return const Text('Failed to load image');
//           },
//           width: double.infinity,
//           height: double.infinity,
//           fit: BoxFit.cover,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await _sendMessage();
//           Navigator.pop(context);
//         },
//         child: const Icon(Icons.send),
//       ),
//     );
//   }
// }
