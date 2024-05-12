import 'package:flutter/material.dart';
import 'package:quick_chat/module/views/profile/profile_setup_screen.dart';

class ProfileDetail extends StatefulWidget {
  final String username;
  final String? bio;
  final String? imageUrl;
  final int followers;
  final int following;
  final int posts;
  final String email;

  const ProfileDetail({
    super.key,
    required this.username,
    this.imageUrl = '',
    this.bio = '',
    required this.email,
    this.followers = 1000,
    this.following = 100,
    this.posts = 365,
  });

  @override
  ProfileDetailState createState() => ProfileDetailState();
}

class ProfileDetailState extends State<ProfileDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: widget.imageUrl!.isNotEmpty
                              ? NetworkImage(widget.imageUrl!)
                              : null, // Set to null if imageUrl is empty
                          child: widget.imageUrl!.isEmpty
                              ? const FlutterLogo() // Show FlutterLogo if imageUrl is empty
                              : null, // Otherwise, show nothing
                        ),

                        // const SizedBox(width: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatColumn('Posts', widget.posts),
                            const SizedBox(width: 20),
                            _buildStatColumn('Followers', widget.followers),
                            const SizedBox(width: 20),
                            _buildStatColumn('Following', widget.following),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.bio ?? "",
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileSetupScreen(email: widget.email),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black38.withOpacity(0.5),
                          padding: const EdgeInsets.all(10),
                          elevation: 0, // Remove elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      color: Colors.lightBlueAccent.withOpacity(0.5),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 6, // Replace with actual number of photos
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Text(
                              'Photo ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
//
// class ProfileDetail extends StatefulWidget {
//   final String username;
//   final String bio;
//   final String imageUrl;
//   final int followers;
//   final int following;
//   final int posts;
//
//   const ProfileDetail({
//     super.key,
//     required this.username,
//     required this.imageUrl,
//     required this.bio,
//     this.followers = 1000,
//     this.following = 100,
//     this.posts = 365,
//   });
//
//   @override
//   ProfileDetailState createState() => ProfileDetailState();
// }
//
// class ProfileDetailState extends State<ProfileDetail> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.arrow_back),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                         const Text(
//                           'Profile',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.settings),
//                           onPressed: () {
//                             // Add functionality for settings
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundImage: NetworkImage(widget.imageUrl),
//                         ),
//                         // const SizedBox(width: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             _buildStatColumn('Posts', widget.posts),
//                             const SizedBox(width: 20),
//                             _buildStatColumn('Followers', widget.followers),
//                             const SizedBox(width: 20),
//                             _buildStatColumn('Following', widget.following),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       widget.username,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       widget.bio,
//                       textAlign: TextAlign.start,
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 20),
//                     Container(
//                       color: Colors.lightBlueAccent.withOpacity(0.5),
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(10),
//                       child: const Text(
//                         'Photos',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 8,
//                         mainAxisSpacing: 8,
//                       ),
//                       itemCount: 6, // Replace with actual number of photos
//                       itemBuilder: (context, index) {
//                         return Container(
//                           color: Colors.grey[200],
//                           child: Center(
//                             child: Text(
//                               'Photo ${index + 1}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatColumn(String label, int value) {
//     return Column(
//       children: [
//         Text(
//           value.toString(),
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }
