import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/helpers/firebase_helper.dart';
import 'package:quick_chat/model/user_model.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({super.key});

  @override
  SearchUsersState createState() => SearchUsersState();
}

class SearchUsersState extends State<SearchUsers> {
  final TextEditingController _searchController = TextEditingController();
  List<UserData> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchUsers(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<DocumentSnapshot> userDocs =
          await FirebaseHelper.fetchAllUserData(query);

      setState(() {
        _searchResults = userDocs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return UserData(
            username: data['username'] ?? '',
            bio: data['bio'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
          );
        }).toList();
      });
    } catch (e) {
      print('Error searching users: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _searchUsers,
          decoration: InputDecoration(
            hintText: 'Search users',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults.clear();
                });
              },
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isNotEmpty
              ? ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            _searchResults[index].imageUrl.isNotEmpty
                                ? NetworkImage(_searchResults[index].imageUrl)
                                : const AssetImage(
                                        'assets/default_profile_image.jpg')
                                    as ImageProvider,
                      ),
                      title: Text(_searchResults[index].username),
                      subtitle: Text(_searchResults[index].bio),
                      onTap: () {
                        // Add functionality to navigate to user's profile
                        // For example:
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => UserProfileScreen(
                        //       user: _searchResults[index],
                        //     ),
                        //   ),
                        // );
                      },
                    );
                  },
                )
              : const Center(
                  child: Text('No users found'),
                ),
    );
  }
}
