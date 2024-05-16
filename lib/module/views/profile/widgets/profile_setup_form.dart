import 'dart:io';

import 'package:flutter/material.dart';

class ProfileSetupForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController bioController;
  final File? image;
  final bool isSaving;
  final VoidCallback getImage;
  final VoidCallback saveProfile;

  const ProfileSetupForm({
    super.key,
    required this.usernameController,
    required this.bioController,
    required this.isSaving,
    required this.getImage,
    required this.saveProfile,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        image != null
            ? CircleAvatar(
                radius: 70,
                backgroundColor: Colors.blueGrey,
                child: ClipOval(
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                    width: 140,
                    height: 140,
                  ),
                ),
              )
            : GestureDetector(
                onTap: getImage,
                child: const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
        const SizedBox(height: 20),
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            hintText: 'Username',
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: bioController,
          decoration: const InputDecoration(
            hintText: 'Bio',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isSaving ? null : saveProfile,
          child:
              isSaving ? const CircularProgressIndicator() : const Text('Save'),
        ),
      ],
    );
  }
}
