import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Screens/addPetScreen.dart';

class AddPetRow extends StatefulWidget {
  @override
  _AddPetRowState createState() => _AddPetRowState();
}

class _AddPetRowState extends State<AddPetRow> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> petImageUrls = [];
  List<String> petNames = [];

  Future<void> _fetchPetImageUrlsAndNames() async {
    // Get the user's UID.
    try {
      // Get the list of all the user's post images from Firebase Storage.
      ListResult result =
          await storage.ref().child('petPics').child(userId).listAll();

      // Create a List to store the fetched download URLs.
      List<String> petFetchedUrls = [];
      List<String> petFetchedNames = [];

      // Iterate through the list of post images and add their download URLs to the fetchedUrls list.
      for (var item in result.items) {
        String downloadUrl = await item.getDownloadURL();
        petFetchedUrls.add(downloadUrl);
      }

      // Reverse the order of fetchedUrls to have the most recent posts appear first.
      petFetchedUrls = petFetchedUrls.reversed.toList();

      // Fetch pet names from Firestore
      QuerySnapshot petSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .get();

      petFetchedNames =
          petSnapshot.docs.map((doc) => doc.get('Pet Name') as String).toList();

      // Assign the fetchedUrls and petNames to the respective lists.
      petImageUrls = petFetchedUrls;
      petNames = petFetchedNames.reversed.toList();
      // Rebuild the UI with the new list of post image URLs and pet names.
      setState(() {});
    } catch (e) {
      // Handle any errors that occur during the fetching of image URLs.
      print('Error fetching post image URLs: $e');
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
      height: h * 0.16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: petImageUrls.length +
            1, // Number of avatars in the row, plus 1 for "Add Pet"
        itemBuilder: (context, index) {
          if (index == 0) {
            // First avatar for "Add Pet"
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPetScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add Pet',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Other avatars
            String imageUrl = petImageUrls[
                index - 1]; // Subtract 1 to account for "Add Pet" avatar
            String petName = petNames[
                index - 1]; // Subtract 1 to account for "Add Pet" avatar
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
          }
        },
      ),
    );
  }
}
