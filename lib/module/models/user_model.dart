import 'package:quick_chat/module/models/post_model.dart';

class User {
  final int id;
  final String username;
  final String bio;
  final int followers;
  final int following;
  final String profileImage;
  final List<Post> posts;

  User({
    required this.id,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.profileImage,
    required this.posts,
  });
}
