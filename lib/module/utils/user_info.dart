import 'package:quick_chat/module/models/post_model.dart';
import 'package:quick_chat/module/models/user_model.dart';

class Users {
  static List<User> users = [
    User(
      id: 1,
      username: 'john_doe',
      bio: 'Flutter enthusiast | Food lover',
      followers: 1000,
      following: 100,
      profileImage: 'assets/img/users/unu.png',
      posts: [
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Beautiful sunset 🌇',
        ),
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Beautiful sunset 🌇',
        ),
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Enjoying beach vibes 🏖️',
        ),
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Exploring the city 🌆',
        ),
      ],
    ),
    User(
      id: 2,
      username: 'jane_smith',
      bio: 'Travel addict | Photography lover',
      followers: 2000,
      following: 150,
      profileImage: 'assets/img/users/unu.png',
      posts: [
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Beautiful sunset 🌇',
        ),
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Enjoying beach vibes 🏖️',
        ),
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Exploring the city 🌆',
        ),
      ],
    ),
    User(
      id: 3,
      username: 'raj_doe',
      bio: 'Flutter enthusiast | Food lover',
      followers: 1000,
      following: 100,
      profileImage: 'assets/img/users/unu.png',
      posts: [
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Beautiful sunset 🌇',
        ),
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Enjoying beach vibes 🏖️',
        ),
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Exploring the city 🌆',
        ),
      ],
    ),
    User(
      id: 4,
      username: 'omar_smith',
      bio: 'Travel addict | Photography lover',
      followers: 2000,
      following: 150,
      profileImage: 'assets/img/users/unu.png',
      posts: [
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Beautiful sunset 🌇',
        ),
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Enjoying beach vibes 🏖️',
        ),
        Post(
          imageUrl: 'assets/img/users/unu.png',
          caption: 'Exploring the city 🌆',
        ),
      ],
    ),
  ];
}
