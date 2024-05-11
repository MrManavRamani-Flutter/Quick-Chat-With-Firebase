import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  @override
  ImagePreviewScreenState createState() => ImagePreviewScreenState();
}

class ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.rotate_left),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              // Reset the image rotation
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  _isLoading = false;
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await _saveImageToDevice(context, widget.imageUrl);
            },
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                loadingBuilder: (context, event) =>
                    const CircularProgressIndicator(),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.contained * 2.5,
                enableRotation: true,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrl),
              ),
      ),
    );
  }

  Future<void> _requestStoragePermission() async {
    var status = await Permission.mediaLibrary.request();
    if (!status.isGranted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Required'),
          content:
              const Text('To save the image, please grant storage permission.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveImageToDevice(BuildContext context, String imageUrl) async {
    var status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      try {
        // Get image bytes
        final imageBytes =
            await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
        final byteData = imageBytes.buffer.asUint8List();

        // final directory = await getExternalStorageDirectory();
        // Get directory for saving
        final imagePath =
            '/storage/emulated/0/DCIM/Camera/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        // '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Save image to the directory
        await File(imagePath).writeAsBytes(byteData);

        // Save image path to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('downloadedImagePath', imagePath);
        // print('Image Path : --------- $imagePath');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save image'),
          ),
        );
      }
    } else if (status.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Required'),
          content:
              const Text('To save the image, please grant storage permission.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      );
    }
  }
}
