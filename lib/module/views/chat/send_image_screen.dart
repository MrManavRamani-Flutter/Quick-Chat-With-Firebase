import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SendImageScreen extends StatefulWidget {
  final String currentUserEmail;
  final String chatRoomId;

  const SendImageScreen({
    Key? key,
    required this.currentUserEmail,
    required this.chatRoomId,
  }) : super(key: key);

  @override
  _SendImageScreenState createState() => _SendImageScreenState();
}

class _SendImageScreenState extends State<SendImageScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  bool _isImageSelected = false;
  bool _isSendingImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _isImageSelected
              ? Image.file(
                  File(_imageUrl!),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )
              : const SizedBox.shrink(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Select Image'),
                onPressed: _pickImage,
              ),
              SizedBox(width: 20),
              _isSendingImage
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('Send'),
                      onPressed: _isImageSelected ? _sendMessage : null,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
        _isImageSelected = true;
      });
    }
  }

  Future<void> _sendMessage() async {
    setState(() {
      _isSendingImage = true;
    });

    try {
      final imageUrl = await _uploadImageToFirestore(File(_imageUrl!));
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'sender': widget.currentUserEmail,
        'imageUrl': imageUrl,
        'time': Timestamp.now(),
      });
      setState(() {
        _isSendingImage = false;
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error sending image: $e');
      setState(() {
        _isSendingImage = false;
      });
    }
  }

  Future<String> _uploadImageToFirestore(File imageFile) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(imageFile);
    await uploadTask.whenComplete(() {});
    return await ref.getDownloadURL();
  }
}

// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// class SendImageScreen extends StatefulWidget {
//   final String imageFile;
//   final String chatRoomId;
//   final String currentUserEmail;
//
//   const SendImageScreen({
//     Key? key,
//     required this.imageFile,
//     required this.chatRoomId,
//     required this.currentUserEmail,
//   }) : super(key: key);
//
//   @override
//   _SendImageScreenState createState() => _SendImageScreenState();
// }
//
// class _SendImageScreenState extends State<SendImageScreen> {
//   late String _uploadedImageUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _uploadImage();
//   }
//
//   Future<void> _uploadImage() async {
//     try {
//       final imageFile = File(widget.imageFile);
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('chat_images')
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
//       final uploadTask = ref.putFile(imageFile);
//       await uploadTask.whenComplete(() {});
//       final imageUrl = await ref.getDownloadURL();
//       setState(() {
//         _uploadedImageUrl = imageUrl;
//       });
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
//
//   Future<void> _sendMessage() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(widget.chatRoomId)
//           .collection('messages')
//           .add({
//         'sender': widget.currentUserEmail,
//         'imageUrl': _uploadedImageUrl,
//         'time': Timestamp.now(),
//       });
//       Navigator.pop(context);
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.file(
//               File(widget.imageFile),
//               width: 150,
//               height: 150,
//               fit: BoxFit.cover,
//             ),
//             InkWell(
//               onTap: _sendMessage,
//               child: Container(
//                   padding: const EdgeInsets.all(10),
//                   child: const Text('Send Image')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
