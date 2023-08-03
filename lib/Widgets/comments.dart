import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Screens/socialmediapage.dart';
import '../Screens/userProfileScreen.dart';

TextEditingController _textEditingController = TextEditingController();

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
        .doc(userId) // Use the actual user ID instead of 'userId'
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

  Future<void> updateLikeStatus(bool newLikeStatus) async {
    if (newLikeStatus) {
      widget.likes.add(userId);
    } else {
      widget.likes.remove(userId);
    }
    isLiked = newLikeStatus;

    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .update({'likes': widget.likes});
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;


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

        // Refresh the comments list by re-fetching the comments
        setState(() {});
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
              MaterialPageRoute(builder: (context) => SocialMediaPage(Si: 0, ci: 0)),
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
                        onTap: () async {
                          bool newLikeStatus = !isLiked;
                          await updateLikeStatus(newLikeStatus);

                          // Refresh the comments list by re-fetching the comments
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.pets,
                            color: isLiked ? Colors.blueAccent : Colors.grey,
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
                  child: CommentList(
                    postId: widget.postId,
                    commentLikes: commentlikes,
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

class CommentList extends StatefulWidget {
  final String postId;
  final List<String> commentLikes;

  CommentList({
    required this.postId,
    required this.commentLikes,
  });

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // Blank container instead of CircularProgressIndicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No comments found.');
        } else {
          List<DocumentSnapshot> commentDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: commentDocs.length,
            itemBuilder: (context, index) {
              bool showReplies = false;
              String commentId = commentDocs[index].id;
              String comment = commentDocs[index].get('comment');
              String profilePic = commentDocs[index].get('profilePic');
              String name = commentDocs[index].get('name');
              String uid = commentDocs[index].get('uid');

              List<String> commentlikes = List<String>.from(
                  (commentDocs[index].data() as Map<String, dynamic>)['likes']
                  as List<dynamic> ??
                      []);

              return CommentItem(
                profilePic: profilePic,
                name: name,
                comment: comment,
                commentLikes: commentlikes,
                commentId: commentId,
                postId: widget.postId,
                updateLikeStatus: (newLikeStatus) async {
                  // Update the comment like status without triggering a full rebuild
                  if (newLikeStatus) {
                    commentlikes.add(userId);
                  } else {
                    commentlikes.remove(userId);
                  }

                  await FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.postId)
                      .collection('comments')
                      .doc(commentId)
                      .update({'likes': commentlikes});
                }, uid: uid,
              );
            },
          );
        }
      },
    );
  }
}

class CommentItem extends StatefulWidget {
  final String profilePic;
  final String name;
  final String comment;
  final List<String> commentLikes;
  final String commentId;
  final String postId;
  final String uid;
  final Function(bool) updateLikeStatus;

  CommentItem({
    required this.profilePic,
    required this.name,
    required this.comment,
    required this.commentLikes,
    required this.commentId,
    required this.postId,
    required this.updateLikeStatus,
    required this.uid,
  });

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  late String userId;

  String? replyUsername;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  List<String> extractUsernames(String comment) {
    List<String> usernames = [];
    RegExp regex = RegExp(r"@\w+");
    Iterable<Match> matches = regex.allMatches(comment);
    for (Match match in matches) {
      String username = match.group(0)!;
      if (!usernames.contains(username)) {
        usernames.add(username);
      }
    }
    return usernames;
  }

  Future<bool> checkUsernameExists(String username) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('usernames').doc(username).get();
      return snapshot.exists;
    } catch (e) {
      print("Error checking username existence: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    List<String> usernames = extractUsernames(widget.comment);
    List<String> commentParts = widget.comment.split(RegExp(r"@\w+"));
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    List<InlineSpan> commentTextSpans = [];
    for (int i = 0; i < commentParts.length; i++) {
      commentTextSpans.add(TextSpan(
          text: commentParts[i], style: TextStyle()));
      if (i < usernames.length) {
        String username = usernames[i];
        commentTextSpans.add(
          TextSpan(
            text: username,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                bool exists = await checkUsernameExists(username);
                if (exists) {
                  if (widget.uid == currentUserId) {
                    // Navigate to the SocialMediaPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SocialMediaPage(Si: 4, ci: 0),
                      ),
                    );
                  } else {
                    // Navigate to the user's profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(userId: widget.uid),
                      ),
                    );
                  }
                }
              },
          ),
        );
      }
    }


    return Column(
      children: [
        Container(
          height: h*0.07,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: w*0.03), // Added left padding
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.profilePic),
                ),
              ),
              SizedBox(width: w*0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: h*0.002),
                    RichText(
                      text: TextSpan(
                        children: commentTextSpans,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: h*0.025),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  // Perform some action on tap
                });
              },
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      handleReplyIconTap(widget.name);
                    },
                    child: Icon(Icons.reply),
                  ),
                  SizedBox(width: w*0.02),
                  InkWell(
                    onTap: () async {
                      bool newLikeStatus = !widget.commentLikes.contains(userId);
                      widget.updateLikeStatus(newLikeStatus);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.pets,
                          color: widget.commentLikes.contains(userId)
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                        SizedBox(width: w*0.02),
                        Text(
                          '${widget.commentLikes.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: w*0.02),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 1,
          color: Colors.black,
        ),
      ],
    );

  }

  void handleReplyIconTap(String username) {
    setState(() {
      replyUsername = username;
    });
    _textEditingController.text = '@$username ';
  }
}


