import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:petterav1/Screens/StrayAnimalsNewPost.dart';
import 'package:petterav1/Screens/socialmediapage.dart';
import 'package:petterav1/Screens/userProfileScreen.dart';
import 'package:share_plus/share_plus.dart';

import '../Widgets/fullScreenImage.dart';
import 'StrayAnimalsComments.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLength;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLength = 100,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.text.length <= widget.maxLength) {
          return Text(widget.text);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isExpanded
                  ? widget.text
                  : '${widget.text.substring(0, widget.maxLength)}...',
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? 'See Less' : 'See More',
                style: const TextStyle(
                  color: Color(0xFFFB9F20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class StrayAnimals extends StatefulWidget {
  const StrayAnimals({Key? key});

  @override
  State<StrayAnimals> createState() => _StrayAnimalsState();
}

class _StrayAnimalsState extends State<StrayAnimals> {
  late Stream<QuerySnapshot> _strayAnimalsStream;

  @override
  void initState() {
    super.initState();
    _strayAnimalsStream = FirebaseFirestore.instance
        .collection('strayanimals')
        .orderBy('datePublished', descending: true)
        .snapshots();
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat.yMMMMd().add_jm();
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.024,
          ),
          Container(
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.07,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SocialMediaPage(
                                Si: 2,
                                ci: 0,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_outlined,
                          // color: Colors.black,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Stray Animals',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Color(0xFFFB9F20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StrayAnimalsNewPost(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth,
                  height: screenWidth * 0.0017,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _strayAnimalsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length + 1,
                    itemBuilder: (context, index) {
                      if (index == documents.length) {
                        // Render the empty container
                        return Container(height: screenHeight * 0.15);
                      }
                      DocumentSnapshot document = documents[index];
                      String photoUrl = document['profImage'];
                      String username = document['username'];
                      Timestamp timestamp = document['datePublished'];
                      DateTime datePublished = timestamp.toDate();
                      String formattedDate = formatDate(datePublished);
                      String caption = document['caption'];
                      String description = document['description'];
                      List<String> postUrls =
                          List<String>.from(document['postUrls']);
                      String? userId = FirebaseAuth.instance.currentUser?.uid;
                      List<String> likes =
                          List<String>.from(document['likes'] ?? []);
                      String location = document['location'];
                      String uid = document['uid'];

                      bool isLiked = likes.contains(userId);

                      final String currentUserId =
                          FirebaseAuth.instance.currentUser?.uid ?? '';

                      return Container(
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: screenHeight * 0.08,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (uid == currentUserId) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SocialMediaPage(
                                                    Si: 4, ci: 0),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileScreen(userId: uid),
                                          ),
                                        );
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(photoUrl),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (uid == currentUserId) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SocialMediaPage(
                                                            Si: 4, ci: 0),
                                                  ),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserProfileScreen(
                                                            userId: uid),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              username,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: screenHeight * 0.02,
                                            color: Colors.black,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.02),
                                          ),
                                          Text(
                                            location,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    caption,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  ExpandableText(
                                    text: description,
                                    maxLength: 100,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04),
                              child: SizedBox(
                                height: screenHeight * 0.13,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          for (int i = 0;
                                              i < 3 && i < postUrls.length;
                                              i++)
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullScreenImage(
                                                              imageUrl:
                                                                  postUrls[i]),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                  ),
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: Image.network(
                                                      postUrls[i],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (postUrls.length <
                                              3) // Gap for the third image
                                            Expanded(
                                                child: Container(
                                                    color: Colors.transparent)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Container(color: Colors.black),
                                    // Black line
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.017),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isLiked) {
                                          likes.remove(userId);
                                        } else {
                                          likes.add(userId!);
                                        }
                                        isLiked = !isLiked;
                                      });

                                      FirebaseFirestore.instance
                                          .collection('strayanimals')
                                          .doc(document.id)
                                          .update({'likes': likes});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Icon(
                                        Icons.pets,
                                        color: isLiked
                                            ? Colors.blueAccent
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.003),
                                    child: Text(
                                      likes.length.toString(),
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        // color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: screenHeight * 0.04,
                                    color: Colors.black,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.02),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StrayAnimalsComments(
                                                    likes: likes,
                                                    username: username,
                                                    description: description,
                                                    uid: uid,
                                                    datePublished:
                                                        datePublished,
                                                    isLiked: isLiked,
                                                    photoUrl: photoUrl,
                                                    document: document,
                                                    caption: caption,
                                                    formattedDate:
                                                        formattedDate,
                                                    location: location,
                                                    postUrls: postUrls,
                                                    timestamp: timestamp)),
                                      );
                                      // Implement comment functionality here
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: screenWidth * 0.01),
                                      child: const Icon(Icons.comment),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: screenHeight * 0.04,
                                    color: Colors.black,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.02),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (postUrls.isNotEmpty) {
                                        String firstImageUrl = postUrls[0];
                                        String postInfo =
                                            "*Checkout the latest post by* $username on animal adoption, only on Pettera app\n\n *Description:* $description\n\n *Date Published:*   '$formattedDate'\n\n *Image:* $firstImageUrl";

                                        await Share.share(postInfo);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: screenWidth * 0.01),
                                      child: const Icon(Icons.share),
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: screenWidth * 0.005),
                                    child: Text(
                                      'Community: Stray Animals',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.02,
                                        // color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
