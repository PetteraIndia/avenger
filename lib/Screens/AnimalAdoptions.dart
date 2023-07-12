import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../Widgets/fullScreenImage.dart';
import 'AnimalAdoptionsNewPost.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLength;

  ExpandableText({
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
                  : widget.text.substring(0, widget.maxLength) + '...',
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? 'See Less' : 'See More',
                style: TextStyle(
                  color: Colors.yellow,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AnimalAdoptions extends StatefulWidget {
  const AnimalAdoptions({Key? key});

  @override
  State<AnimalAdoptions> createState() => _AnimalAdoptionsState();
}

class _AnimalAdoptionsState extends State<AnimalAdoptions> {
  late Stream<QuerySnapshot> _animalAdoptionsStream;

  @override
  void initState() {
    super.initState();
    _animalAdoptionsStream = FirebaseFirestore.instance
        .collection('animaladoptions')
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
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.07,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.16,
                          ),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              'Animal Adoptions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: const Color(0xFFFB9F20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimalAdoptionsNewPost(),
                            ),
                          );
                        },
                        icon: Icon(
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
              stream: _animalAdoptionsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length + 1,
                    itemBuilder: (context, index) {
                      if (index == documents.length) {
                        // Render the empty container
                        return Container(height: screenHeight * 0.1);
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

                      bool isLiked = likes.contains(userId);

                      return Container(
                        decoration: BoxDecoration(
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
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(photoUrl),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            username,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(Icons.more_vert),
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
                                    style: TextStyle(
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
                                    SizedBox(height: 1),
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
                                          .collection('animaladoptions')
                                          .doc(document.id)
                                          .update({'likes': likes});
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(7.0),
                                      child: Icon(
                                        Icons.pets,
                                        color: isLiked
                                            ? Colors.yellow
                                            : Colors.black,
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
                                        color: Colors.black,
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
                                      // Implement comment functionality here
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: screenWidth * 0.01),
                                      child: Icon(Icons.comment),
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
                                      // Implement share functionality here
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: screenWidth * 0.01),
                                      child: Icon(Icons.share),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: screenWidth * 0.005),
                                    child: Text(
                                      'Community: Animal Adoptions',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.02,
                                        color: Colors.black,
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
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
