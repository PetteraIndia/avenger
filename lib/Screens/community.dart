import 'package:flutter/material.dart';
import 'package:petterav1/Screens/AnimalAdoptions.dart';
import 'package:petterav1/Screens/AnimalDiscussions.dart';
import 'package:petterav1/Screens/AnimalEmergency.dart';
import 'package:petterav1/Screens/LostAnimals.dart';
import 'package:petterav1/Screens/PetDiscussions.dart';
import 'package:petterav1/Screens/socialmediapage.dart';

import 'StrayAnimals.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool isCommunitySelected = true;
  int selectedIndex = 0; // To track the selected tab

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SocialMediaPage(Si: 2)),
            );
          },
        ), // Remove the default back arrow
        title: Container(
          height: screenHeight * 0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Perform search action
                },
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search the community & resources',
                    hintStyle: TextStyle(fontSize: 15),
                    // Set the font size here
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Perform menu action
            },
          ),
        ],
      ),
      body: selectedIndex == 1
          ? AnimalAdoptions()
          : selectedIndex == 2
              ? AnimalEmergency()
              : selectedIndex == 3
                  ? LostAnimals()
                  : selectedIndex == 4
                      ? StrayAnimals()
                      : selectedIndex == 5
                          ? Animaldiscussions()
                          : selectedIndex == 6
                              ? PetDiscussions()
                              : Column(
                                  children: [
                                    Container(
                                      height: screenHeight * 0.08,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black45,
                                                width: 1.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isCommunitySelected = true;
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: screenWidth * 0.17),
                                                child: Text(
                                                  'Community',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        isCommunitySelected
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                    color: isCommunitySelected
                                                        ? Colors.black
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1.0,
                                              color: Colors.black45,
                                              height: screenHeight * 0.05,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isCommunitySelected = false;
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: screenWidth * 0.17),
                                                child: Text(
                                                  'Resources',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        !isCommunitySelected
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                    color: !isCommunitySelected
                                                        ? Colors.black
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: isCommunitySelected
                                            ? Container(
                                                // Content for Community tab
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                          height: screenWidth *
                                                              0.05),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedIndex =
                                                                    1;
                                                              });
                                                            },
                                                            child: Container(
                                                              width:
                                                                  screenWidth *
                                                                      0.41,
                                                              height:
                                                                  screenHeight *
                                                                      0.15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: const Color(
                                                                    0xFFFB9F20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        4,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Animal',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Adoptions',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedIndex =
                                                                    2;
                                                              });
                                                            },
                                                            child: Container(
                                                              width:
                                                                  screenWidth *
                                                                      0.41,
                                                              height:
                                                                  screenHeight *
                                                                      0.15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: const Color(
                                                                    0xFFFB9F20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        4,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Animal',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Emergency',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedIndex =
                                                                    3;
                                                              });
                                                            },
                                                            child: Container(
                                                              width:
                                                                  screenWidth *
                                                                      0.41,
                                                              height:
                                                                  screenHeight *
                                                                      0.15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: const Color(
                                                                    0xFFFB9F20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        4,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Lost',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Animals',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedIndex =
                                                                    4;
                                                              });
                                                            },
                                                            child: Container(
                                                              width:
                                                                  screenWidth *
                                                                      0.41,
                                                              height:
                                                                  screenHeight *
                                                                      0.15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: const Color(
                                                                    0xFFFB9F20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        4,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Stray',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Animals',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedIndex =
                                                                    5;
                                                              });
                                                            },
                                                            child: Container(
                                                              width:
                                                                  screenWidth *
                                                                      0.41,
                                                              height:
                                                                  screenHeight *
                                                                      0.15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: const Color(
                                                                    0xFFFB9F20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        4,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Animal',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Discussions',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedIndex =
                                                                    6;
                                                              });
                                                            },
                                                            child: Container(
                                                              width:
                                                                  screenWidth *
                                                                      0.41,
                                                              height:
                                                                  screenHeight *
                                                                      0.15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: const Color(
                                                                    0xFFFB9F20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        4,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Pet',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Discussions',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                // Content for Resources tab
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: Center(
                                                  child:
                                                      Text('Resources Content'),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
    );
  }
}
