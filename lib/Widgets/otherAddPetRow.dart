import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class OtherAddPetRow extends StatefulWidget {
  final String userId;

  const OtherAddPetRow({Key? key, required this.userId}) : super(key: key);

  @override
  _OtherAddPetRowState createState() => _OtherAddPetRowState();
}

class _OtherAddPetRowState extends State<OtherAddPetRow> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> petImageUrls = [];
  List<String> petNames = [];

  Future<void> _fetchPetImageUrlsAndNames() async {
    try {
      // Get the list of all the user's pet images from Firebase Storage.
      ListResult result =
          await storage.ref().child('petPics').child(widget.userId).listAll();

      // Create a List to store the fetched download URLs.
      List<String> petFetchedUrls = [];
      List<String> petFetchedNames = [];

      // Iterate through the list of pet images and add their download URLs to the fetchedUrls list.
      for (var item in result.items) {
        String downloadUrl = await item.getDownloadURL();
        petFetchedUrls.add(downloadUrl);
      }

      // Reverse the order of petFetchedUrls to match the order in Firestore.
      petFetchedUrls = petFetchedUrls.reversed.toList();

      // Fetch pet names from Firestore
      QuerySnapshot petSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('pets')
          .get();

      petFetchedNames =
          petSnapshot.docs.map((doc) => doc.get('Pet Name') as String).toList();

      // Assign the fetchedUrls and petNames to the respective lists.
      petImageUrls = petFetchedUrls;
      petNames = petFetchedNames.reversed.toList();

      // Rebuild the UI with the new list of pet image URLs and pet names.
      setState(() {});
    } catch (e) {
      // Handle any errors that occur during the fetching of image URLs.
      print('Error fetching pet image URLs: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPetImageUrlsAndNames();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Container(
      height: h * 0.13,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: petImageUrls.length,
        itemBuilder: (context, index) {
          String imageUrl = petImageUrls[index];
          String petName = petNames[index];

          return Container(
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                SizedBox(height: 8),
                Text(
                  petName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
