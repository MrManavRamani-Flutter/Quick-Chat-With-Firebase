import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Chat'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("Home Screen"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Index of the current tab
        onTap: (int index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/settings');
              break;
            case 2:
              Navigator.pushNamed(context, '/favorites');
              break;
            case 3:
              Navigator.pushNamed(context, '/chat');
              break;
          }
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
