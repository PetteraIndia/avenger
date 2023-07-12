import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/socialmediapage.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postUrl;
  final String username;
  final String postedTimeAgo;
  final String description;
  final int datePublished;
  final String uid;
  final List<String> likes;
  final int currentTime;
  late final bool isLiked;
  final String profImage;

  Comments({
    required this.postId,
    required this.postedTimeAgo,
    required this.likes,
    required this.currentTime,
    required this.postUrl,
    required this.username,
    required this.description,
    required this.uid,
    required this.datePublished,
    required this.isLiked,
    required this.profImage,
  });

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  late bool isLiked;
  late String userId;
  String userPhotoUrl = '';
  List<String> commentlikes = [];

  Future<void> fetchUserPhotoUrl() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('userId') // Replace 'userId' with the actual user ID
        .get();
    setState(() {
      userPhotoUrl = snapshot.get('photoUrl');
    });
  }

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    userId = FirebaseAuth.instance.currentUser!.uid;
    fetchUserPhotoUrl();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    TextEditingController _textEditingController = TextEditingController();

    void _handleSendIconTap() async {
      String comment = _textEditingController.text.trim();
      if (comment.isNotEmpty) {
        // Text field is not empty
        // Perform action for non-empty comment
        print('Comment: $comment , $userId');

        // Get the current timestamp
        Timestamp timestamp = Timestamp.now();

        // Fetch the user's username and profile picture URL from Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        String username = userSnapshot.get('Username');
        String profilePic = userSnapshot.get('photoUrl');

        // Generate a unique comment ID
        String commentId = FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .doc()
            .id;

        // Create a new comment document in Firestore
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'uid': userId,
          'commentId': commentId,
          'datePublished': timestamp,
          'likes': [],
          'name': username,
          'profilePic': profilePic,
          'comment': comment,
        });

        // Clear the text field
        _textEditingController.clear();
      } else {
        // Text field is empty
        // Perform action for empty comment
        print('No comment entered');
      }
    }

    @override
    void dispose() {
      _textEditingController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            Text(
              "Comments",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.0),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SocialMediaPage(Si: 0)),
            );
          },
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: w * 0.001,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: h * 0.39,
            width: w * 1,
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Container(
                  height: h * 0.06,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          radius: h * 0.05,
                          backgroundImage: NetworkImage(widget.profImage),
                        ),
                      ),
                      Expanded(
                        child: Text(widget.username),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Perform action on three-dot icon tap
                          },
                          child: Icon(Icons.more_vert),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: h * 0.25,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.postUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: h * 0.04,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isLiked) {
                              widget.likes.remove(userId);
                            } else {
                              widget.likes.add(userId);
                            }
                            isLiked = !isLiked;
                          });

                          FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.postId)
                              .update({'likes': widget.likes});
                        },
                        child: Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.pets,
                            color: isLiked ? Colors.yellow : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        widget.likes.length.toString(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Posted ${widget.postedTimeAgo} ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: h * 0.04,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(widget.description),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: h * 0.07,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: h * 0.023,
                          backgroundImage: AssetImage("img/logo.jpeg"),
                        ),
                        SizedBox(width: h * 0.017),
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Enter a comment',
                            ),
                          ),
                        ),
                        SizedBox(width: h * 0.017),
                        GestureDetector(
                          onTap: _handleSendIconTap,
                          child: Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: h * 0.0001,
                  color: Colors.black,
                ),
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId)
                        .collection('comments')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Text('No comments found.');
                      } else {
                        List<DocumentSnapshot> commentDocs =
                            snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: commentDocs.length,
                          itemBuilder: (context, index) {
                            bool showReplies = false;
                            String commentId = commentDocs[index].id;
                            String comment = commentDocs[index].get('comment');
                            String profilePic =
                                commentDocs[index].get('profilePic');
                            String name = commentDocs[index].get('name');

                            List<String> commentlikes = List<String>.from(
                                (commentDocs[index].data()
                                            as Map<String, dynamic>)['likes']
                                        as List<dynamic> ??
                                    []);

                            return Column(
                              children: [
                                Container(
                                  height: h * 0.07,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: h * 0.023,
                                        backgroundImage:
                                            NetworkImage(profilePic),
                                      ),
                                      SizedBox(width: h * 0.017),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: w * 0.0017),
                                          Text(comment),
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: h * 0.017),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showReplies = !showReplies;
                                              });
                                            },
                                            child: Icon(Icons.reply),
                                          ),
                                          SizedBox(width: h * 0.017),
                                          GestureDetector(
                                            onTap: () async {
                                              // Replace with the actual user ID

                                              final commentRef =
                                                  FirebaseFirestore.instance
                                                      .collection('posts')
                                                      .doc(widget.postId)
                                                      .collection('comments')
                                                      .doc(commentId);

                                              final commentDoc =
                                                  await commentRef.get();
                                              List<String> likesc =
                                                  List<String>.from(commentDoc
                                                          .data()?['likes'] ??
                                                      []);

                                              if (likesc.contains(userId)) {
                                                likesc.remove(userId);
                                              } else {
                                                likesc.add(userId);
                                              }

                                              await commentRef
                                                  .update({'likes': likesc});

                                              setState(() {
                                                commentlikes = likesc;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.pets,
                                                  color: commentlikes
                                                          .contains(userId)
                                                      ? Colors.yellow
                                                      : Colors.black,
                                                ),
                                                SizedBox(width: w * 0.02),
                                                Text(
                                                  '${commentlikes.length}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: w * 0.03),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (showReplies)
                                  Container(
                                    height: h * 0.1,
                                    color: Colors.white,
                                  ),
                                Container(
                                  height: h * 0.0008,
                                  color: Colors.black,
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
