import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:petterav1/Widgets/CommunityTab.dart';
import 'package:petterav1/Widgets/addPetsRow.dart';
import 'package:provider/provider.dart';

import '../Widgets/PostTab.dart';
import '../Widgets/StampTab.dart';
import '../main.dart';
import 'LoginScreen.dart';
import 'editProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> postImageUrls = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _signOut(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.signOut();
      await _googleSignIn.signOut(); // Sign out from Google
      // Sign out from Firebase

      // Navigate to the sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> _fetchPostImageUrls() async {
    // Get the user's UID.
    String uid = userId;

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
          .doc(userId)
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
          .doc(userId)
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
    loadProfileImage();
    _fetchPostImageUrls();
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkModeEnabled = themeNotifier.isDarkModeEnabled;

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
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
                        child: IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
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
                      height: h * 0.2,
                    ),
                    Center(
                      child: Text(
                        userFullName,
                        style: TextStyle(
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        userBio,
                        style: TextStyle(
                          fontSize: w * 0.035,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines:
                            2, // Set the desired number of lines or use null for unlimited lines
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    AddPetRow(),
                    Container(
                      height: h * 0.001,
                      width: w * 1,
                      color: isDarkModeEnabled ? Colors.white : Colors.black,
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
                                ),
                              ),
                              Text(
                                'Posts',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
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
                          color:
                              isDarkModeEnabled ? Colors.white : Colors.black,
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
                          color:
                              isDarkModeEnabled ? Colors.white : Colors.black,
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
                      color: isDarkModeEnabled ? Colors.white : Colors.black,
                    ),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            //labelColor: Colors.black,
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
                                StampTab(userId: userId),
                                CommunityTab(userId: userId),
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
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notes),
              title: Text('About Us'),
              onTap: () {
                // Navigate to About Us screen
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _signOut(context);
              },
            ),
            SwitchListTile(
              title: Text('Theme'),
              value: isDarkModeEnabled,
              onChanged: (value) {
                themeNotifier.toggleTheme();
              },
            ),
            // Add other Drawer items here...
          ],
        ),
      ),
    );
  }
}
