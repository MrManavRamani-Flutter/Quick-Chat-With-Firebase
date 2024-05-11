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
  SendImageScreenState createState() => SendImageScreenState();
}

class SendImageScreenState extends State<SendImageScreen> {
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Select Image'),
                onPressed: _pickImage,
              ),
              const SizedBox(width: 20),
              _isSendingImage
                  ? const CircularProgressIndicator()
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
