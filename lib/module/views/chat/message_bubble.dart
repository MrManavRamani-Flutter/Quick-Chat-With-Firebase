import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String? message;
  final String? imageUrl;
  final bool isMe;
  final DateTime time;
  final bool isSelected;
  final bool showCheckbox;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onDeletePressed;

  const MessageBubble({
    super.key,
    this.message,
    this.imageUrl,
    required this.isMe,
    required this.time,
    required this.isSelected,
    required this.showCheckbox,
    this.onCheckboxChanged,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('hh:mm a');
    final formattedTime = timeFormat.format(time);

    return Container(
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: isMe ? 5 : 15,
        right: isMe ? 15 : 5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isMe && showCheckbox)
                      Checkbox(
                        value: isSelected,
                        onChanged: onCheckboxChanged,
                      ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? 20 : 0),
                          topRight: Radius.circular(isMe ? 0 : 20),
                          bottomLeft: const Radius.circular(20),
                          bottomRight: const Radius.circular(20),
                        ),
                        border: isSelected
                            ? Border.all(color: Colors.red, width: 2)
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imageUrl != null)
                            GestureDetector(
                              onTap: () {
                                // Handle image tap
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl!,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const CircularProgressIndicator(
                                        color: Colors.blue,
                                      );
                                    }
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
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
                              color: isMe
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isMe && showCheckbox)
            Checkbox(
              value: isSelected,
              onChanged: onCheckboxChanged,
            ),
          if (isMe && onDeletePressed != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDeletePressed,
            ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import 'image_preview_screen.dart';
//
// class MessageBubble extends StatelessWidget {
//   final String? message;
//   final String? imageUrl;
//   final bool isMe;
//   final DateTime time;
//
//   const MessageBubble({
//     super.key,
//     this.message,
//     this.imageUrl,
//     required this.isMe,
//     required this.time,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final timeFormat = DateFormat('hh:mm a');
//     final formattedTime = timeFormat.format(time);
//
//     return Container(
//       margin: EdgeInsets.only(
//         top: 5,
//         bottom: 5,
//         left: isMe ? 60 : 10,
//         right: isMe ? 10 : 60,
//       ),
//       child: Column(
//         crossAxisAlignment:
//             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             decoration: BoxDecoration(
//               color: isMe ? Colors.blue : Colors.grey[200],
//               borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(20),
//                 topRight: const Radius.circular(20),
//                 bottomLeft:
//                     isMe ? const Radius.circular(20) : const Radius.circular(0),
//                 bottomRight:
//                     isMe ? const Radius.circular(0) : const Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (imageUrl != null)
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ImagePreviewScreen(
//                             imageUrl: imageUrl!,
//                           ),
//                         ),
//                       );
//                     },
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(
//                         imageUrl!,
//                         loadingBuilder: (BuildContext context, Widget child,
//                             ImageChunkEvent? loadingProgress) {
//                           if (loadingProgress == null) {
//                             return child;
//                           } else {
//                             return const CircularProgressIndicator(
//                               color: Colors.blue,
//                             );
//                           }
//                         },
//                         errorBuilder: (BuildContext context, Object exception,
//                             StackTrace? stackTrace) {
//                           return const Text('Failed to load image');
//                         },
//                         width: 150,
//                         height: 150,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 if (message != null) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     message!,
//                     style: TextStyle(
//                       color: isMe ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 4),
//                 Text(
//                   formattedTime,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: isMe ? Colors.white : Colors.black.withOpacity(0.6),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
