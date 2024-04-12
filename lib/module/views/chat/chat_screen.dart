import 'package:flutter/material.dart';
import 'package:quick_chat/module/models/user_model.dart';
import 'package:quick_chat/module/views/chat/widgets/message_bubble.dart';
import 'package:quick_chat/module/views/chat/widgets/message_input_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User userInfo = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text(userInfo.username),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('user_profile', arguments: userInfo);
            },
            child: CircleAvatar(
              child: Image(image: AssetImage(userInfo.profileImage)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: const [
                MessageBubble(isSentByMe: true, message: "Hey"),
                MessageBubble(isSentByMe: false, message: "Hey! How are you?"),
                MessageBubble(
                    isSentByMe: true, message: "Fine! How about you?"),
              ],
            ),
          ),
          const MessageInputField(),
        ],
      ),
    );
  }
}
