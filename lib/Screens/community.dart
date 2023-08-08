import 'package:flutter/material.dart';
import 'package:petterav1/Screens/AnimalAdoptions.dart';
import 'package:petterav1/Screens/AnimalDiscussions.dart';
import 'package:petterav1/Screens/AnimalEmergency.dart';
import 'package:petterav1/Screens/LostAnimals.dart';
import 'package:petterav1/Screens/PetDiscussions.dart';
import 'package:petterav1/Screens/resources/resources.dart';

import 'StrayAnimals.dart';

class CommunityScreen extends StatefulWidget {
  final int ci;
  const CommunityScreen({super.key, 
    required this.ci,
  });

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool isCommunitySelected = true;
  int selectedIndex = 0; // To track the selected tab
  @override
  void initState() {
    super.initState();
    if (widget.ci == 1 ||
        widget.ci == 2 ||
        widget.ci == 3 ||
        widget.ci == 4 ||
        widget.ci == 5 ||
        widget.ci == 6) {
      setState(() {
        selectedIndex = widget.ci;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: selectedIndex == 1
          ? const AnimalAdoptions()
          : selectedIndex == 2
              ? const AnimalEmergency()
              : selectedIndex == 3
                  ? const LostAnimals()
                  : selectedIndex == 4
                      ? const StrayAnimals()
                      : selectedIndex == 5
                          ? const AnimalDiscussions()
                          : selectedIndex == 6
                              ? const PetDiscussions()
                              : Column(
                                  children: [
                                    Container(
                                      height: screenHeight * 0.05,
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.08,
                                      child: Container(
                                        decoration: const BoxDecoration(
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
                                                    fontSize: 19.0,
                                                    fontWeight:
                                                        isCommunitySelected
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                    // color: isCommunitySelected
                                                    //     ? Colors.black
                                                    //     : Colors.grey,
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
                                                    fontSize: 19.0,
                                                    fontWeight:
                                                        !isCommunitySelected
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                    // color: !isCommunitySelected
                                                    //     ? Colors.black
                                                    //     : Colors.grey,
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
                                                      const SizedBox(height: 10),
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
                                                      const SizedBox(height: 10),
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
                                                decoration: const BoxDecoration(),
                                                child:
                                                    const Resources(), // Replace `Text('Resources Content')` with `Resources()`
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
    );
  }
}
