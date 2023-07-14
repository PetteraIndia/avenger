import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StampTab extends StatelessWidget {
  final String userId;

  const StampTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading pets'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final petDocs = snapshot.data!.docs;

        if (petDocs.isEmpty) {
          return Center(
            child: Text('No pets found'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: List.generate(
              petDocs.length,
              (index) {
                final petData = petDocs[index].data() as Map<String, dynamic>;
                final petName = petData['Pet Name'] ?? '';
                final petBreed = petData['Pet Breed'] ?? '';
                final petDOB = petData['Pet DOB'] ?? '';
                final photoUrl = petData['PhotoUrl'] ?? '';

                return Container(
                  height: 120, // Increase the height as desired
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF07203F),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(photoUrl),
                      ),
                      SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            petName,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            children: [
                              Text(
                                petBreed,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                petDOB,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          // Handle View Stamps button press
                        },
                        child: Text(
                          'View Stamps',
                          style: TextStyle(
                            fontSize: 16.0,
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
          ),
        );
      },
    );
  }
}
