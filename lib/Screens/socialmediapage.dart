import 'package:flutter/material.dart';
import 'package:petterav1/Screens/community.dart';
import 'package:petterav1/Screens/profile_screen.dart';
import 'package:petterav1/Screens/services.dart';
import 'package:petterav1/Screens/notification.dart';
import 'package:petterav1/Widgets/social_postwidget.dart';

class SocialMediaPage extends StatefulWidget {
  final int Si;
  final int ci;

  SocialMediaPage({
    required this.Si,
    required this.ci,
  });

  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  int selectedIndex = 0;
  bool isContainerOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.Si == 1 || widget.Si == 2 || widget.Si == 3 || widget.Si == 4) {
      setState(() {
        selectedIndex = widget.Si;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double postContainerHeight = screenSize.height * 0.43;
    final double floatingBarHeight = screenSize.height * 0.101;
    final double floatingBarWidth = screenSize.width * 0.9;
    final double floatingBarBottomOffset = screenSize.height * 0.035;

    return Scaffold(
      body: Stack(
        children: [
          buildBodyWidget(screenSize, postContainerHeight, floatingBarHeight),
          Positioned(
            bottom: floatingBarBottomOffset,
            left: (screenSize.width - floatingBarWidth) / 2,
            child: buildFloatingBarWidget(floatingBarHeight, floatingBarWidth),
          ),
        ],
      ),
    );
  }

  Widget buildBodyWidget(
      Size screenSize, double postContainerHeight, double floatingBarHeight) {
    if (selectedIndex == 0) {
      return SocialPostWidget(
        screenSize: screenSize,
        postContainerHeight: postContainerHeight,
        floatingBarHeight: floatingBarHeight,
      );
    } else if (selectedIndex == 1) {
      return ServicesScreen();
    } else if (selectedIndex == 2) {
      return CommunityScreen(ci: widget.ci);
    } else if (selectedIndex == 4) {
      return ProfileScreen();
    } else {
      return Center(
        child: Text(
          buildIcon(Icons.home, 'Social', 0).toString(),
          style: TextStyle(fontSize: 24),
        ),
      );
    }
  }

  Widget buildFloatingBarWidget(
      double floatingBarHeight, double floatingBarWidth) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
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
                      color: selectedIndex == 0 ? Colors.black : Colors.white),
                  Text(
                    'Social',
                    style: TextStyle(
                      color: selectedIndex == 0 ? Colors.black : Colors.white,
                    ),
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
                      color: selectedIndex == 1 ? Colors.black : Colors.white),
                  Text(
                    'Services',
                    style: TextStyle(
                      color: selectedIndex == 1 ? Colors.black : Colors.white,
                    ),
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
                      color: selectedIndex == 2 ? Colors.black : Colors.white),
                  Text(
                    'Community',
                    style: TextStyle(
                      color: selectedIndex == 2 ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 4;
                });
              },
              child: Column(
                children: [
                  Icon(Icons.person,
                      color: selectedIndex == 4 ? Colors.black : Colors.white),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: selectedIndex == 4 ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
