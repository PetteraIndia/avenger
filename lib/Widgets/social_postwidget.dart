import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petterav1/Screens/newpost.dart';
import 'package:petterav1/resources/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
  bool showOverlay = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // showOverlay = !showOverlay;
        });
      },
      child: Column(
        children: [
          SizedBox(height: widget.screenSize.height * 0.01), // Space below floating bar
          Expanded(
            child: Stack(
              children: [
            StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator if data is still loading
              }

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data?.docs[index];
                  var profImage = doc?['profImage'];
                  var username = doc?['username'];
                  var postUrl = doc?['postUrl'];
                  var description = doc?['description'];

                  return Container(
                    height: widget.postContainerHeight * 1,
                    width: widget.screenSize.width,
                    color: Colors.grey[200],
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Container(
                          height: widget.postContainerHeight * 1.5 / 10,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(7.0),
                                child: CircleAvatar(
                                  radius: widget.postContainerHeight * 2 / 20,
                                  backgroundImage: NetworkImage(profImage),
                                ),
                              ),
                              Expanded(
                                child: Text(username),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Perform action on three-dot icon tap
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.more_vert),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: widget.postContainerHeight * 5.5 / 10,
                          color: Colors.green,
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

                        Container(
                          height: widget.postContainerHeight * 1.5 / 10,
                          color: Colors.white,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle paw icon tap
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.pets,
                                    color: Colors.black, // Adjust the color accordingly
                                  ),
                                ),
                              ),
                              Text('2'),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 7.0),
                                child: Container(
                                  width: 1.0,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(Icons.comment),
                              Padding(
                                padding: EdgeInsets.only(left: 4.0, right: 8.0),
                                child: Text('Comment'),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      'Right Text',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12, // Adjust the font size as desired
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: widget.postContainerHeight * 1.2 / 10,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
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

            },
          ),




      Positioned(
                  bottom: widget.screenSize.height * 0.1,
                  right: widget.screenSize.width * 0.05,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showOverlay = !showOverlay;
                      });
                    },
                    child: Container(
                      height: widget.screenSize.height * 0.07,
                      width: widget.screenSize.height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
                if (showOverlay)
                  Positioned(
                    bottom: widget.screenSize.height * 0.17,
                    right: widget.screenSize.width * 0.05,
                    child: Container(
                      height: widget.screenSize.height * 0.2,
                      width: widget.screenSize.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => newpost()),
                                );
                                print("new post clicked");
                                // Add your desired functionality when "New Post" is pressed
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'New Post',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Container(
                                    height: 0.2,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {

                                // Add your desired functionality when "Add Stamp" is pressed
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Add Stamp',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Container(
                                    height: 0.2,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Add your desired functionality when "Log Out" is pressed
                                AuthService().signOut();
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Container(
                                    height: 0.2,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
              ],
            ),
          ),
          SizedBox(height: widget.floatingBarHeight * 0.3), // Space below floating bar
        ],
      ),
    );
  }
}
