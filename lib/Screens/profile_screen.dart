import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Widgets/userDetails.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 50, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

String getUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String userId = user.uid;
    return userId;
  } else {
    return '';
  }
}

Future<String> getProfileImageUrl() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No signed-in user found.");
    }

    final profileImageUrl = await FirebaseStorage.instance
        .ref()
        .child('profilePics')
        .child(user.uid)
        .getDownloadURL();

    return profileImageUrl;
  } catch (e) {
    // Handle any potential errors here
    print('Error retrieving current user profile image URL: $e');
    return ''; // Return an empty string or provide a default fallback URL
  }
}

Future<String> getCurrentUserFullName() async {
  String userId =
      getUserId(); // Get the current user's ID (e.g., from FirebaseAuth)

  try {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String fullName = userData['Full Name'] ?? '';
      return fullName;
    } else {
      return '';
    }
  } catch (e) {
    // Handle any potential errors here
    print('Error retrieving user full name: $e');
    return '';
  }
}

Future<String> getUserBio() async {
  String userId =
      getUserId(); // Get the current user's ID (e.g., from FirebaseAuth)

  try {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String userBio = userData['bio'] ?? '';
      return userBio;
    } else {
      return '';
    }
  } catch (e) {
    // Handle any potential errors here
    print('Error retrieving user bio: $e');
    return '';
  }
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userImageUrl = '';
  String userFullName = '';
  String userBio = '';
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    final imageUrl = await getProfileImageUrl();
    final fullName = await getCurrentUserFullName();
    final currentUserBio = await getUserBio();
    setState(() {
      userImageUrl = imageUrl;
      userBio = currentUserBio;
      userFullName = fullName;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: h * .2,
                color: Colors.blue,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: w * 0.1, right: w * 0.06),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Add your button's functionality here
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.27,
                    ),
                    Center(
                      child: Text(
                        userFullName,
                        style: TextStyle(
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        userBio,
                        style: TextStyle(
                          fontSize: w * 0.035,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                        maxLines:
                            2, // Set the desired number of lines or use null for unlimited lines
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '28',
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Posts',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: w * 0.02), // Adjust the spacing as needed
                        Container(
                          height: h * 0.05,
                          width: w * 0.005,
                          color: Colors.black,
                        ),
                        SizedBox(
                            width: w * 0.02), // Adjust the spacing as needed
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '931',
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Buddies',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: w * 0.02), // Adjust the spacing as needed
                        Container(
                          height: h * 0.05,
                          width: w * 0.005,
                          color: Colors.black,
                        ),
                        SizedBox(
                            width: w * 0.02), // Adjust the spacing as needed
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '712',
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Container(
                        height: h * 0.001, width: w * 1, color: Colors.black),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text(
                            'Posts',
                            style: TextStyle(
                              fontSize: w * 0.035, // Set the desired font size
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Stamp Book',
                            style: TextStyle(
                              fontSize: w * 0.035, // Set the desired font size
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Community',
                            style: TextStyle(
                              fontSize: w * 0.035, // Set the desired font size
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.05,
                    ),
                    // StreamBuilder<QuerySnapshot>(
                    //   stream: FirebaseFirestore.instance
                    //       .collection('posts')
                    //       .where('uid', isEqualTo: userId)
                    //       .snapshots(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasError) {
                    //       return Center(child: Text('Error fetching posts'));
                    //     }

                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return Center(child: CircularProgressIndicator());
                    //     }

                    //     if (snapshot.hasData) {
                    //       final posts = snapshot.data!.docs;

                    //       return GridView.builder(
                    //         gridDelegate:
                    //             SliverGridDelegateWithFixedCrossAxisCount(
                    //           crossAxisCount: 2, // Number of posts per row
                    //           crossAxisSpacing:
                    //               10.0, // Spacing between posts horizontally
                    //           mainAxisSpacing:
                    //               10.0, // Spacing between posts vertically
                    //         ),
                    //         itemCount: posts.length,
                    //         itemBuilder: (context, index) {
                    //           final post = posts[index];

                    //           // Replace 'imageUrl' with the field name that stores the post image URL in your Firestore document
                    //           final imageUrl = post['imageUrl'];

                    //           return Image.network(
                    //             imageUrl,
                    //             fit: BoxFit.cover,
                    //           );
                    //         },
                    //       );
                    //     }

                    //     return Container();
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: h * 0.03,
              left: w * 0.25,
              right: w * 0.25,
              child: Container(
                height: h * .3,
                width: w * 0.7,
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: w * 0.2,
                      backgroundImage: NetworkImage(userImageUrl),
                    ),
                    Positioned(
                      top: h * 0.21,
                      left: w * 0.25,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: w * 0.06,
                      ),
                    ),
                    Positioned(
                      top: h * 0.13,
                      left: w * 0.37,
                      child: CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: w * 0.06,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
