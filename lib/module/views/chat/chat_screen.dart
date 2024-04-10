import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
        centerTitle: true,
        actions: const [
          FlutterLogo(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      color: Colors.blue.shade50,
                      margin: const EdgeInsets.all(5),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Hey",
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "5:30 PM",
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.end,
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.done_all,
                              color: Colors.blueAccent,
                              size: 13,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Card(
                      color: Colors.blue.shade50,
                      margin: const EdgeInsets.all(5),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Hey! How are you?",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      color: Colors.blue.shade50,
                      margin: const EdgeInsets.all(5),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Fine! How About you?",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const TextField(
                decoration: InputDecoration(
              hintText: "Enter your message",
            )),
          ),
        ],
      ),
    );
  }
}
