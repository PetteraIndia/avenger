import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petterav1/Screens/newpost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petterav1/Screens/userProfileScreen.dart';
import 'package:petterav1/Widgets/comments.dart';

import '../Screens/socialmediapage.dart';
import 'user_search_logic.dart';

import '../Screens/notification.dart';

ScrollController _scrollController = ScrollController();

@override
class SocialPostWidget extends StatefulWidget {
  const SocialPostWidget({
    Key? key,
    required this.screenSize,
    required this.postContainerHeight,
    required this.floatingBarHeight,
  }) : super(key: key);

  final Size screenSize;
  final double postContainerHeight;
  final double floatingBarHeight;

  @override
  _SocialPostWidgetState createState() => _SocialPostWidgetState();
}

class _SocialPostWidgetState extends State<SocialPostWidget> {
  bool showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();
  bool showOverlay = false;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getTimeAgo(int milliseconds) {
    var difference = Duration(milliseconds: milliseconds).abs();
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  Widget buildPostContainer(QuerySnapshot? snapshot) {
    if (snapshot == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var docs = snapshot.docs;
    docs.sort((a, b) {
      var timestampA = a['datePublished'];
      var timestampB = b['datePublished'];
      return timestampB.compareTo(timestampA);
    });

    return ListView.builder(
      controller: _scrollController,
      itemCount: docs.length + 1,
      itemBuilder: (context, index) {
        if (index == docs.length) {
          return Container(height: widget.screenSize.height * 0.1);
        }
        var doc = docs[index];
        var profImage = doc['profImage'];
        var username = doc['username'];
        var postUrl = doc['postUrl'];
        var description = doc['description'];
        var datePublished =
            (doc['datePublished'] as Timestamp).toDate().millisecondsSinceEpoch;
        var likes = List<String>.from(doc['likes'] ?? []);
        var uid = doc['uid'];
        var postId = doc['postId'];
        var currentTime = DateTime.now().millisecondsSinceEpoch;
        var postedTimeAgo = _getTimeAgo((currentTime - datePublished).toInt());
        bool isLiked = likes.contains(FirebaseAuth.instance.currentUser?.uid);
        var userId = FirebaseAuth.instance.currentUser?.uid;
        final String currentUserId =
            FirebaseAuth.instance.currentUser?.uid ?? '';

        return Container(
          height: widget.postContainerHeight * 1,
          width: widget.screenSize.width,
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              SizedBox(
                height: widget.postContainerHeight * 1.5 / 10,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: GestureDetector(
                        onTap: () {
                          if (uid == currentUserId) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SocialMediaPage(Si: 4, ci: 0),
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
                          radius: widget.postContainerHeight * 2 / 20,
                          backgroundImage: NetworkImage(profImage),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (uid == currentUserId) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SocialMediaPage(Si: 4, ci: 0),
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
                        child: Text(username),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: widget.postContainerHeight * 6 / 10,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(postUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: widget.postContainerHeight * 1.5 / 10,
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
                            .collection('posts')
                            .doc(doc.id)
                            .update({'likes': likes});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.pets,
                          color: isLiked ? Colors.blueAccent : Colors.grey,
                        ),
                      ),
                    ),
                    Text(likes.length.toString()),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 7.0),
                      child: Container(
                        width: 1.0,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Comments(
                                    postId: postId,
                                    postedTimeAgo: postedTimeAgo,
                                    likes: likes,
                                    currentTime: currentTime,
                                    postUrl: postUrl,
                                    username: username,
                                    description: description,
                                    uid: uid,
                                    datePublished: datePublished,
                                    isLiked: isLiked,
                                    profImage: profImage,
                                  )),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.comment),
                          Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 8.0),
                            child: Text('Comment'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Posted $postedTimeAgo ',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
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
              SizedBox(
                height: widget.postContainerHeight * 1 / 10,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(description),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(widget.screenSize.height * 0.08),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserSearch()),
                  );
                },
                child:
                    Icon(Icons.search, size: widget.screenSize.height * 0.04),
              ),
              GestureDetector(
                onTap: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Image.asset('img/petterablue.png',
                    height: widget.screenSize.height * 0.15),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsPage(),
                    ),
                  );
                },
                child: Icon(Icons.notifications_active_outlined,
                    size: widget.screenSize.height * 0.04),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.black,
              height: widget.screenSize.height * 0.0004,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: widget.screenSize.height * 0.01),
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    return buildPostContainer(snapshot.data);
                  },
                ),
                Positioned(
                  bottom: widget.screenSize.height * 0.12,
                  right: widget.screenSize.width * 0.05,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const newpost()),
                      );
                    },
                    child: Container(
                      height: widget.screenSize.height * 0.07,
                      width: widget.screenSize.height * 0.07,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: widget.floatingBarHeight * 0.3),
        ],
      ),
    );
  }
}
