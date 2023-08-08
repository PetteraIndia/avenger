import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:petterav1/Screens/userProfileScreen.dart';

import '../Screens/socialmediapage.dart';
import '../Widgets/fullScreenImage.dart';
import 'AnimalAdoptions.dart';

TextEditingController _textEditingController = TextEditingController();

class StrayAnimalsComments extends StatefulWidget {
  final DocumentSnapshot document;

  final String username;
  final String caption;
  final String description;
  final DateTime datePublished;
  final String formattedDate;
  final String uid;
  final List<String> likes;
  final List<String> postUrls;
  final bool isLiked;
  final String photoUrl;
  final String location;
  final Timestamp timestamp;
  const StrayAnimalsComments({
    super.key,
    required this.likes,
    required this.username,
    required this.description,
    required this.uid,
    required this.datePublished,
    required this.isLiked,
    required this.photoUrl,
    required this.document,
    required this.caption,
    required this.formattedDate,
    required this.location,
    required this.postUrls,
    required this.timestamp,
  });

  @override
  _StrayAnimalsCommentsState createState() => _StrayAnimalsCommentsState();
}

class _StrayAnimalsCommentsState extends State<StrayAnimalsComments> {
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
        .collection('strayanimals')
        .doc(widget.document.id)
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
            .collection('strayanimals')
            .doc(widget.document.id)
            .collection('comments')
            .doc()
            .id;

        // Create a new comment document in Firestore
        await FirebaseFirestore.instance
            .collection('strayanimals')
            .doc(widget.document.id)
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
        title: const Row(
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
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SocialMediaPage(Si: 2, ci: 4)),
            );
          },
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
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
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: h * 0.08,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.photoUrl),
                      ),
                      SizedBox(width: w * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: h * 0.02,
                                color: Colors.black,
                                margin:
                                    EdgeInsets.symmetric(horizontal: w * 0.02),
                              ),
                              Text(
                                widget.location,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Text(
                            widget.formattedDate,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.caption,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      ExpandableText(
                        text: widget.description,
                        maxLength: 100,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: SizedBox(
                    height: h * 0.13,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              for (int i = 0;
                                  i < 3 && i < widget.postUrls.length;
                                  i++)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              imageUrl: widget.postUrls[i]),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.network(
                                          widget.postUrls[i],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (widget.postUrls.length <
                                  3) // Gap for the third image
                                Expanded(
                                    child:
                                        Container(color: Colors.transparent)),
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
                SizedBox(height: h * 0.017),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
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
                              .collection('strayanimals')
                              .doc(widget.document.id)
                              .update({'likes': widget.likes});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.pets,
                            color: isLiked ? Colors.blueAccent : Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: w * 0.003),
                        child: Text(
                          widget.likes.length.toString(),
                          style: TextStyle(
                            fontSize: w * 0.04,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: h * 0.04,
                        color: Colors.black,
                        margin: EdgeInsets.symmetric(horizontal: w * 0.02),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Implement share functionality here
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: w * 0.01),
                          child: const Icon(Icons.share),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: w * 0.005),
                        child: Text(
                          'Community: Stray Animals',
                          style: TextStyle(
                            fontSize: w * 0.02,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: w * 0.008),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: h * 0.07,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: h * 0.023,
                          backgroundImage: const AssetImage("img/logo.jpeg"),
                        ),
                        SizedBox(width: h * 0.017),
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            decoration: const InputDecoration(
                              hintText: 'Enter a comment',
                            ),
                          ),
                        ),
                        SizedBox(width: h * 0.017),
                        GestureDetector(
                          onTap: _handleSendIconTap,
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: h * 0.0001,
                  color: Colors.black45,
                ),
                Expanded(
                  child: CommentList(
                    postId: widget.document.id,
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

  const CommentList({
    super.key,
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
          .collection('strayanimals')
          .doc(widget.postId)
          .collection('comments')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // Blank container instead of CircularProgressIndicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No comments found.');
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
                      .collection('strayanimals')
                      .doc(widget.postId)
                      .collection('comments')
                      .doc(commentId)
                      .update({'likes': commentlikes});
                },
                uid: uid,
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

  const CommentItem({
    super.key,
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
      var snapshot = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .get();
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
          text: commentParts[i], style: const TextStyle(color: Colors.grey)));
      if (i < usernames.length) {
        String username = usernames[i];
        commentTextSpans.add(
          TextSpan(
            text: username,
            style: const TextStyle(
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
                        builder: (context) =>
                            const SocialMediaPage(Si: 4, ci: 0),
                      ),
                    );
                  } else {
                    // Navigate to the user's profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfileScreen(userId: widget.uid),
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
        SizedBox(
          height: h * 0.07,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: w * 0.03), // Added left padding
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.profilePic),
                ),
              ),
              SizedBox(width: w * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: h * 0.002),
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
        SizedBox(height: h * 0.025),
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
                    child: const Icon(Icons.reply),
                  ),
                  SizedBox(width: w * 0.02),
                  InkWell(
                    onTap: () async {
                      bool newLikeStatus =
                          !widget.commentLikes.contains(userId);
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
                        SizedBox(width: w * 0.02),
                        Text(
                          '${widget.commentLikes.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: w * 0.02),
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
