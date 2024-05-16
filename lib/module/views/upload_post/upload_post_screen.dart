import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';

class UploadPostScreen extends StatefulWidget {
  final String email;

  const UploadPostScreen({super.key, required this.email});

  @override
  UploadPostScreenState createState() => UploadPostScreenState();
}

class UploadPostScreenState extends State<UploadPostScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadPost() async {
    if (_imageFile != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        await FirebaseHelper.uploadUserPost(
          email: widget.email,
          imageFile: _imageFile!,
        );

        setState(() {
          _isUploading = false;
          _imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post uploaded successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        print('Error uploading post: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Post')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isUploading)
                      const CircularProgressIndicator()
                    else
                      Column(
                        children: [
                          _imageFile == null
                              ? const Text('No image selected.')
                              : Image.file(
                                  _imageFile!,
                                  height: constraints.maxHeight * 0.4,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text('Pick Image'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _uploadPost,
                            child: const Text('Upload Post'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
