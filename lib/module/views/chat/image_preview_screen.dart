import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imageUrl;

  const ImagePreviewScreen({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _isLoading = false;

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

  Future<void> _saveImageToDevice(BuildContext context, String imageUrl) async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        final response = await ImageGallerySaver.saveImage(
          Uint8List.fromList(
            (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
                .buffer
                .asUint8List(),
          ),
          quality: 100,
          name: 'image_${DateTime.now().millisecondsSinceEpoch}',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image saved to gallery at $response'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save image'),
          ),
        );
      }
    } else if (status.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Permission Required'),
          content: Text('To save the image, please grant storage permission.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: Text('Settings'),
            ),
          ],
        ),
      );
    }
  }

  // Future<void> _saveImageToDevice(BuildContext context, String imageUrl) async {
  //   var status = await Permission.storage.request();
  //
  //   if (status.isGranted) {
  //     try {
  //       final response = await ImageGallerySaver.saveImage(
  //         Uint8List.fromList(
  //           (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
  //               .buffer
  //               .asUint8List(),
  //         ),
  //         quality: 100,
  //         name: 'image_${DateTime.now().millisecondsSinceEpoch}',
  //         copyToClipboard: true,
  //         // Let user choose the directory for downloading
  //         requestPermission: true,
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Image saved to gallery at $response'),
  //         ),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Failed to save image'),
  //         ),
  //       );
  //     }
  //   } else if (status.isPermanentlyDenied) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         title: const Text('Permission Required'),
  //         content:
  //             const Text('To save the image, please grant storage permission.'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               openAppSettings();
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Settings'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:photo_view/photo_view.dart';
//
// class ImagePreviewScreen extends StatefulWidget {
//   final String imageUrl;
//
//   const ImagePreviewScreen({Key? key, required this.imageUrl})
//       : super(key: key);
//
//   @override
//   ImagePreviewScreenState createState() => ImagePreviewScreenState();
// }
//
// class ImagePreviewScreenState extends State<ImagePreviewScreen> {
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.rotate_left),
//             onPressed: () {
//               setState(() {
//                 _isLoading = true;
//               });
//               // Reset the image rotation
//               Future.delayed(const Duration(milliseconds: 500), () {
//                 setState(() {
//                   _isLoading = false;
//                 });
//               });
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.download),
//             onPressed: () async {
//               await _saveImageToDevice(context, widget.imageUrl);
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : PhotoView(
//                 imageProvider: NetworkImage(widget.imageUrl),
//                 loadingBuilder: (context, event) =>
//                     const CircularProgressIndicator(),
//                 backgroundDecoration: const BoxDecoration(color: Colors.black),
//                 minScale: PhotoViewComputedScale.contained * 0.8,
//                 maxScale: PhotoViewComputedScale.contained * 2.5,
//                 enableRotation: true,
//                 heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrl),
//               ),
//       ),
//     );
//   }
//
//   Future<void> _saveImageToDevice(BuildContext context, String imageUrl) async {
//     var status = await Permission.storage.request();
//
//     if (status.isGranted) {
//       try {
//         var response = await ImageGallerySaver.saveImage(
//           Uint8List.fromList(
//             (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
//                 .buffer
//                 .asUint8List(),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Image saved to gallery'),
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to save image'),
//           ),
//         );
//       }
//     } else if (status.isPermanentlyDenied) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: const Text('Permission Required'),
//           content:
//               const Text('To save the image, please grant storage permission.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 openAppSettings();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Settings'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

//-----------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
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
//         child: PhotoView(
//           imageProvider: NetworkImage(imageUrl),
//           loadingBuilder: (context, event) => const Center(
//             child: CircularProgressIndicator(),
//           ),
//           backgroundDecoration: const BoxDecoration(
//             color: Colors.black,
//           ),
//           minScale: PhotoViewComputedScale.contained * 0.8,
//           maxScale: PhotoViewComputedScale.contained * 2.5,
//           enableRotation: true,
//           heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
//         ),
//       ),
//     );
//   }
// }
