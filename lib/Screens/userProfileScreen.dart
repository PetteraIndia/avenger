import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:petterav1/Widgets/otherAddPetRow.dart';

import '../Widgets/CommunityTab.dart';
import '../Widgets/PostTab.dart';
import '../Widgets/StampTab.dart';
import '../Widgets/fullScreenImage.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
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
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userImageUrl = '';
  String userFullName = '';
  String userBio = '';
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> postImageUrls = [];
  bool isFollowing = false;

  Future<void> _fetchPostImageUrls() async {
    // Get the user's UID.
    String uid = widget.userId;

    try {
      // Get the list of all the user's post images from Firebase Storage.
      ListResult result =
          await storage.ref().child('posts').child(uid).listAll();

      // Create a List to store the fetched download URLs.
      List<String> fetchedUrls = [];

      // Iterate through the list of post images and add their download URLs to the fetchedUrls list.
      for (var item in result.items) {
        String downloadUrl = await item.getDownloadURL();
        fetchedUrls.add(downloadUrl);
      }

      // Reverse the order of fetchedUrls to have the most recent posts appear first.
      fetchedUrls = fetchedUrls.reversed.toList();

      // Assign the fetchedUrls to postImageUrls list.
      postImageUrls = fetchedUrls;

      // Rebuild the UI with the new list of post image URLs.
      setState(() {});
    } catch (e) {
      // Handle any errors that occur during the fetching of image URLs.
      print('Error fetching post image URLs: $e');
    }
  }

  Future<int> getTotalFollowersCount() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        List<dynamic> followers = userData['followers'] ?? [];

        return followers.length;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error retrieving total followers count: $e');
      return 0;
    }
  }

  Future<int> getTotalFollowingCount() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        List<dynamic> following = userData['following'] ?? [];

        return following.length;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error retrieving total following count: $e');
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchPostImageUrls();
    loadUserProfile();
    checkIsFollowing();
  }

  Future<void> loadUserProfile() async {
    final imageUrl = await getProfileImageUrl(widget.userId);
    final fullName = await getUserFullName(widget.userId);
    final userBio = await getUserBio(widget.userId);
    setState(() {
      userImageUrl = imageUrl;
      userFullName = fullName;
      this.userBio = userBio;
    });
  }

  Future<String> getProfileImageUrl(String userId) async {
    try {
      final profileImageUrl = await FirebaseStorage.instance
          .ref()
          .child('profilePics')
          .child(userId)
          .getDownloadURL();

      return profileImageUrl;
    } catch (e) {
      print('Error retrieving user profile image URL: $e');
      return ''; // Return an empty string or provide a default fallback URL
    }
  }

  Future<String> getUserFullName(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        String fullName = userData['Full Name'] ?? '';
        return fullName;
      } else {
        return '';
      }
    } catch (e) {
      print('Error retrieving user full name: $e');
      return '';
    }
  }

  Future<String> getUserBio(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        String userBio = userData['bio'] ?? '';
        return userBio;
      } else {
        return '';
      }
    } catch (e) {
      print('Error retrieving user bio: $e');
      return '';
    }
  }

  Future<void> followUser() async {
    // Get the current user's ID
    String currentUserId = await getUserId();

    // Add the other user's ID to the current user's following list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({
      'following': FieldValue.arrayUnion([widget.userId])
    });

    // Add the current user's ID to the other user's followers list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({
      'followers': FieldValue.arrayUnion([currentUserId])
    });

    setState(() {
      isFollowing = true;
    });
  }

  Future<void> unfollowUser() async {
    // Get the current user's ID
    String currentUserId = await getUserId();

    // Remove the other user's ID from the current user's following list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({
      'following': FieldValue.arrayRemove([widget.userId])
    });

    // Remove the current user's ID from the other user's followers list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({
      'followers': FieldValue.arrayRemove([currentUserId])
    });

    setState(() {
      isFollowing = false;
    });
  }

  Future<String> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      return userId;
    } else {
      return '';
    }
  }

  Future<void> checkIsFollowing() async {
    String currentUserId = await getUserId();

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      List<dynamic> following = userData['following'] ?? [];

      setState(() {
        isFollowing = following.contains(widget.userId);
      });
    }
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
                height: h * .15,
                color: Colors.blue,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: w * 0.08, right: w * 0.06),
                        child: Container(
                          child: isFollowing
                              ? ElevatedButton(
                                  onPressed: unfollowUser,
                                  child: Text('Following'),
                                )
                              : ElevatedButton(
                                  onPressed: followUser,
                                  child: Text('Follow'),
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
                      height: h * 0.23,
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
                    OtherAddPetRow(userId: widget.userId),
                    Container(
                      height: h * 0.001,
                      width: w * 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: h * 0.01,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '${postImageUrls.length}',
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
                          width: w * 0.02,
                        ), // Adjust the spacing as needed
                        Container(
                          height: h * 0.05,
                          width: w * 0.005,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: w * 0.02,
                        ), // Adjust the spacing as needed
                        Expanded(
                          child: Column(
                            children: [
                              FutureBuilder<int>(
                                future: getTotalFollowersCount(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      '${snapshot.data}',
                                      style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                              Text(
                                'Followers',
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
                          width: w * 0.02,
                        ), // Adjust the spacing as needed
                        Container(
                          height: h * 0.05,
                          width: w * 0.005,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: w * 0.02,
                        ), // Adjust the spacing as needed
                        Expanded(
                          child: Column(
                            children: [
                              FutureBuilder<int>(
                                future: getTotalFollowingCount(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      '${snapshot.data}',
                                      style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
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
                      height: h * 0.01,
                    ),
                    Container(
                      height: h * 0.001,
                      width: w * 1,
                      color: Colors.black,
                    ),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.blue,
                            tabs: [
                              Tab(
                                child: Text(
                                  'Posts',
                                  style: TextStyle(fontSize: w * 0.035),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'Stamp Book',
                                  style: TextStyle(fontSize: w * 0.035),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'Community',
                                  style: TextStyle(fontSize: w * 0.035),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: h * 0.6, // Adjust the height as needed
                            child: TabBarView(
                              children: [
                                PostGridView(postImageUrls: postImageUrls),
                                StampTab(userId: widget.userId),
                                CommunityTab(userId: widget.userId),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: h * 0,
              left: w * 0.25,
              right: w * 0.25,
              child: Container(
                height: h * .27,
                width: w * 0.7,
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: w * 0.2,
                      backgroundImage: NetworkImage(userImageUrl),
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
