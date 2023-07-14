import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:petterav1/Screens/socialmediapage.dart';

class AnimalEmergencyNewPost extends StatefulWidget {
  const AnimalEmergencyNewPost({Key? key}) : super(key: key);

  @override
  State<AnimalEmergencyNewPost> createState() => _AnimalEmergencyNewPostState();
}



class _AnimalEmergencyNewPostState extends State<AnimalEmergencyNewPost> {
  final captionController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  bool isPosting = false;
  List<File> selectedImages = [];
  int maxImageCount = 4;

  Future<File> compressImage(String imagePath) async {
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final compressedPath = '${appDir.path}/compressed_image.jpg';

    await FlutterImageCompress.compressAndGetFile(
      imagePath,
      compressedPath,
      quality: 37,
      rotate: 0,
    );

    return File(compressedPath);
  }

  Future<void> postIt(BuildContext context) async {
    if (captionController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        locationController.text.isEmpty ||
        selectedImages.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incomplete Entries'),
            content: Text('Please fill all the fields and select at least one image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userId = user.uid;
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final photoUrl = userDoc.get('photoUrl');
        final username = userDoc.get('Username');
        final storageRef = FirebaseStorage.instance.ref();
        final postsCollection = FirebaseFirestore.instance.collection('animalemergency');
        final batch = FirebaseFirestore.instance.batch();
        final communitycollection = FirebaseFirestore.instance.collection('usersdata').doc(userId).collection('community').doc();

        List<String> imageUrls = [];

        for (int i = 0; i < selectedImages.length; i++) {
          final selectedImage = selectedImages[i];
          final compressedImage = await compressImage(selectedImage.path);
          final storagePath =
              'animalemergency/$userId/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          final uploadTask = storageRef.child(storagePath).putFile(compressedImage);
          final snapshot = await uploadTask.whenComplete(() {});
          final downloadUrl = await snapshot.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        }

        final newPostDoc = postsCollection.doc();
        batch.set(newPostDoc, {
          'datePublished': FieldValue.serverTimestamp(),
          'description': descriptionController.text,
          'likes': [],
          'postId': newPostDoc.id,
          'postUrls': imageUrls,
          'profImage': photoUrl,
          'uid': userId,
          'username': username,
          'location': locationController.text,
          'caption': captionController.text,
        });
        batch.set(communitycollection, {
          'datePublished': FieldValue.serverTimestamp(),
          'description': descriptionController.text,
          'postId': newPostDoc.id,
          'postUrls': imageUrls,
          'profImage': photoUrl,
          'uid': userId,
          'username': username,
          'location': locationController.text,
          'caption': captionController.text,
          'community':'Animal Emergency',
        });

        await batch.commit();

        captionController.clear();
        locationController.clear();
        descriptionController.clear();
        setState(() {
          selectedImages.clear();
        });

        print('Images uploaded!');
      }
    }
  }


  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages != null && pickedImages.length <= maxImageCount) {
      setState(() {
        selectedImages = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Animal Emergency',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SocialMediaPage(Si: 2,ci: 2)),
            );
          },
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: w * 0.002,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(h * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Add pictures and videos',
                    style: TextStyle(fontSize: h * 0.022),
                  ),
                  SizedBox(width: w * 0.30),
                  InkWell(
                    onTap: _selectImage,
                    child: Icon(Icons.add_box_outlined, size: w * 0.08),
                  ),
                ],
              ),
              SizedBox(height: h * 0.02),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: h * 0.0002,
                  ),
                ),
                height: h * 0.25,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (selectedImages.isNotEmpty)
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: h * 0.25,
                            child: Image.file(selectedImages[index], fit: BoxFit.contain),
                          );
                        },
                      ),
                    if (selectedImages.isEmpty)
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.pets, size: h * 0.04),
                            SizedBox(width: h * 0.02),
                            Text('Please choose images'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.02),
              TextField(
                controller: captionController,
                decoration: InputDecoration(hintText: 'Enter the title..'),
              ),
              SizedBox(height: h * 0.02),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Enter the description'),
              ),
              SizedBox(height: h * 0.02),
              TextField(
                controller: locationController,
                decoration: InputDecoration(hintText: 'Add a location'),
              ),
              SizedBox(height: h * 0.15),
              Center(
                child: isPosting
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: h * 0.04),
                    Text('Posting...'),
                  ],
                )
                    : GestureDetector(
                  onTap: () async{
                    setState(() {
                      isPosting = true;
                    });
                    await postIt(context).then((_) {
                      setState(() {
                        isPosting = false;
                      });
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SocialMediaPage(Si: 2,ci: 2)),
                    );
                  },
                  child: Container(
                    height: h * 0.05,
                    width: w * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: h * 0.03,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
