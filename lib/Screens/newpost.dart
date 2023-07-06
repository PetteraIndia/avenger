import 'package:flutter/material.dart';
import 'package:petterav1/Screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petterav1/Screens/signup_screen.dart';
import 'package:petterav1/resources/auth_service.dart';
import 'dart:io';
import 'globals.dart';

import 'package:petterav1/Screens/newpostedit.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


File? image = selectedImage;

class newpost extends StatefulWidget {
  const newpost({Key? key}) : super(key: key);

  @override
  State<newpost> createState() => _newpostState();
}

class _newpostState extends State<newpost> {
  final captionController = TextEditingController();
  final locationController = TextEditingController();
  final buddiesController = TextEditingController();
  bool isPosting = false;


  Future<File> compressImage(String imagePath) async {
    // Get the directory for saving the compressed image
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final compressedPath = '${appDir.path}/compressed_image.jpg';

    // Compress the image
    await FlutterImageCompress.compressAndGetFile(
      imagePath,
      compressedPath,
      quality: 80, // Adjust the quality level (0 to 100)
      rotate: 0, // Adjust the rotation angle (in degrees, 0 to 360)
    );

    return File(compressedPath);
  }


  Future<void> postIt(BuildContext context) async {
    if (captionController.text.isEmpty ||
        locationController.text.isEmpty ||
        buddiesController.text.isEmpty ||
        selectedImage == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incomplete Entries'),
            content: Text('Please fill all the fields.'),
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
    }
    else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        // Compress the image
        final compressedImage = await compressImage(selectedImage!.path);

        // Upload the compressed image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('posts/$userId/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(compressedImage);

        // Get the download URL once the upload is complete
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Clear the fields and selectedImage after posting
        captionController.clear();
        locationController.clear();
        buddiesController.clear();
        setState(() {
          selectedImage = null;
        });

        print('Image uploaded! Download URL: $downloadUrl');
      }
    }

  }




  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);


    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
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
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {
              if(selectedImage!=null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => newpostedit()),
                );
              }
              else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Image not Found'),
                      content: Text('Please sellect an image'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }


            },
          ),
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: w*0.002,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child:
          Container(
            padding: EdgeInsets.all(h*0.02), // Adjust the padding as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Add pictures and videos',
                      style: TextStyle(fontSize: h*0.022),
                    ),
                    SizedBox(width: w*0.35
                    ),
                    InkWell(
                      onTap: _selectImage,
                      child: Icon(Icons.add_box_outlined, size: w*0.08),
                    ),
                  ],
                ),
                SizedBox(height: h*0.02),
                Container(
                  decoration: BoxDecoration(

                    border: Border.all(
                      color: Colors.black,
                      width: h*0.0002,
                    ),
                  ),

                  height: h * 0.25,
                  // color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (selectedImage != null)
                        Align(
                          alignment: Alignment.center,
                          child: Image.file(selectedImage!, fit: BoxFit.contain),
                        ),
                      if (selectedImage == null)
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pets, size: h*0.04),
                              SizedBox(width: h*0.02),
                              Text('Please choose an image'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.02),
                TextField(
                  controller: captionController,
                  decoration: InputDecoration(hintText: 'Enter a caption..'),
                ),
                SizedBox(height: h * 0.02),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(hintText: 'Add location'),
                ),
                SizedBox(height: h * 0.02),
                TextField(
                  controller: buddiesController,
                  decoration: InputDecoration(hintText: 'Tag your buddies'),
                ),
                SizedBox(height: h * 0.15),
                Center(
                  child: isPosting
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(), // Circular progress indicator
                      SizedBox(height: h*0.04),
                      Text('Posting...'), // Text indicating the posting state
                    ],
                  )
                      : GestureDetector(
                    onTap: () {
                      setState(() {
                        isPosting = true;
                      });
                      postIt(context).then((_) {
                        setState(() {
                          isPosting = false;
                        });
                      });
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
                            fontSize: h*0.03,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),




                SizedBox(height: h*0.05),
          Container(
            height: h * 0.03,
            width: w * 0.2,
            decoration: BoxDecoration(
              color: Colors.blue, // Replace with your desired color
              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
            ),
            child: GestureDetector(
              onTap: () {
                AuthService().signOut();
              },
              child: Center(
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white, // Replace with your desired text color
                    fontSize: 16.0, // Replace with your desired font size
                  ),
                ),
              ),
            ),
          ),

          ],
            ),
          ),

      ),

    );
  }
}
