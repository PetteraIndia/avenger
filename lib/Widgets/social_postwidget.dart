import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petterav1/Screens/newpost.dart';
import 'package:petterav1/resources/auth_service.dart';

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
                ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      height: widget.postContainerHeight,
                      width: widget.screenSize.width,
                      color: Colors.grey[200],
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('Post $index'),
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
