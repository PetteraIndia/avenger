import 'package:flutter/material.dart';
import 'package:petterav1/Screens/community.dart';
import 'package:petterav1/Screens/profile_screen.dart';
import 'package:petterav1/Screens/search.dart';
import 'package:petterav1/Screens/services.dart';
import 'package:petterav1/Screens/notification.dart';
import 'package:petterav1/Widgets/social_postwidget.dart';

class SocialMediaPage extends StatefulWidget {
  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  int selectedIndex = 0; // Default selected index
  bool isContainerOpen = false;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double appBarHeight = kToolbarHeight;
    final double postContainerHeight = screenSize.height * 0.43;
    final double floatingBarHeight = screenSize.height * 0.1;
    final double floatingBarWidth = screenSize.width * 0.9;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: screenSize.height * 0.03),
      child: Stack(
        children: [
          Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenSize.height * 0.08),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 1,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('img/petterablue.png',
                        height: screenSize.height * 0.15),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width * 0.05),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationsPage()),
                          );
                        },
                        child: Icon(Icons.notifications_active_outlined,
                            size: screenSize.height * 0.04),
                      ),
                    ),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(1),
                  child: Container(
                    color: Colors.black,
                    height: screenSize.height * 0.0004,
                  ),
                ),
              ),
            ),
            body: selectedIndex == 0
                ? SocialPostWidget(
                    screenSize: screenSize,
                    postContainerHeight: postContainerHeight,
                    floatingBarHeight: floatingBarHeight,
                  )
                : selectedIndex == 1
                    ? ServicesScreen()
                    : selectedIndex == 2
                        ? CommunityScreen()
                        : selectedIndex == 3
                            ? SearchScreen()
                            : selectedIndex == 4
                                ? ProfileScreen()
                                : Center(
                                    child: Text(
                                      buildIcon(Icons.home, 'Social', 0)
                                          .toString(),
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              height: floatingBarHeight,
              width: floatingBarWidth,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(29),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(screenSize.height * 0.016),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.home,
                              color: selectedIndex == 0
                                  ? Colors.black
                                  : Colors.white),
                          Text(
                            'Social',
                            style: TextStyle(
                                color: selectedIndex == 0
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.widgets,
                              color: selectedIndex == 1
                                  ? Colors.black
                                  : Colors.white),
                          Text(
                            'Services',
                            style: TextStyle(
                                color: selectedIndex == 1
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.pets,
                              color: selectedIndex == 2
                                  ? Colors.black
                                  : Colors.white),
                          Text(
                            'Community',
                            style: TextStyle(
                                color: selectedIndex == 2
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.search,
                              color: selectedIndex == 3
                                  ? Colors.black
                                  : Colors.white),
                          Text(
                            'Search',
                            style: TextStyle(
                                color: selectedIndex == 3
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 4;
                        });
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ProfileScreen()),
                        // );
                      },
                      child: Column(
                        children: [
                          Icon(Icons.person,
                              color: selectedIndex == 4
                                  ? Colors.black
                                  : Colors.white),
                          Text(
                            'Profile',
                            style: TextStyle(
                                color: selectedIndex == 4
                                    ? Colors.black
                                    : Colors.white),
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
    );
  }

  Widget buildIcon(IconData icon, String label, int index) {
    final Color iconColor =
        selectedIndex == index ? Colors.black : Colors.white;
    final TextStyle textStyle = TextStyle(color: iconColor);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor),
          Text(label, style: textStyle),
        ],
      ),
    );
  }
}
