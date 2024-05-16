import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/model/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final UserData user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.imageUrl.isNotEmpty ==
                true) // Check if imageUrl is not null or empty
              CircleAvatar(
                backgroundImage: NetworkImage(user.imageUrl),
                radius: 50,
              ),
            const SizedBox(height: 16),
            Text(
              'Username: ${user.username}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Bio: ${user.bio}',
              // Use empty string if bio is null
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Posts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: FirebaseHelper.fetchUserPostsByEmail1(user.email),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No posts found.'),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          _showPostModal(context, post['imageURL']);
                        },
                        child: Image.network(
                          post['imageURL'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostModal(BuildContext context, String imageUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
