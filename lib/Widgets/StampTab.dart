import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

import '../Screens/stampScree.dart';

class StampTab extends StatelessWidget {
  final String userId;

  const StampTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading pets'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final petDocs = snapshot.data!.docs;

        if (petDocs.isEmpty) {
          return const Center(
            child: Text('No pets found'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(
                petDocs.length,
                (index) {
                  final petData = petDocs[index].data() as Map<String, dynamic>;
                  final petName = petData['Pet Name'] ?? '';
                  final petBreed = petData['Pet Breed'] ?? '';
                  final petDOB = petData['Pet DOB'] ?? '';
                  final photoUrl = petData['PhotoUrl'] ?? '';

                  // Convert petDOB to DateTime object
                  final dob = DateTime.parse(petDOB);
                  // Calculate age based on current date
                  final age = DateTime.now().difference(dob).inDays ~/ 365;

                  return Container(
                    height: h * 0.13, // Increase the height as desired
                    margin: EdgeInsets.symmetric(vertical: h * 0.01),
                    padding: EdgeInsets.all(w * 0.02),
                    decoration: BoxDecoration(
                      color: const Color(0xFF07203F),
                      borderRadius: BorderRadius.circular(w * 0.02),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: w * 0.08,
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                        SizedBox(width: w * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              petName,
                              style: TextStyle(
                                fontSize: w * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: w * 0.01),
                            Row(
                              children: [
                                Text(
                                  petBreed,
                                  style: TextStyle(
                                    fontSize: w * 0.03,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: w * 0.02), // Add spacing
                                Text(
                                  '|',
                                  style: TextStyle(
                                    fontSize: w * 0.03,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: w * 0.02), // Add spacing
                                Text(
                                  '$age years', // Display age in years
                                  style: TextStyle(
                                    fontSize: w * 0.03,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Handle View Stamps button press
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StampScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'View Stamps',
                            style: TextStyle(
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                  height: h *
                      0.02), // Add some spacing between the pet containers and the empty container
              Container(
                height: h * 0.1, // Adjust the height as desired
              ),
            ],
          ),
        );
      },
    );
  }
}
