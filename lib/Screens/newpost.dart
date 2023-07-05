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
File? image = selectedImage;

class newpost extends StatefulWidget {
  const newpost({Key? key}) : super(key: key);

  @override
  State<newpost> createState() => _newpostState();
}

class _newpostState extends State<newpost> {



  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
      //
      // // final user = FirebaseAuth.instance.currentUser; // Get the current user
      // if (user != null) {
      //   final userId = user.uid;
      //
      //   // Upload the image to Firebase Storage
      //   final storageRef = FirebaseStorage.instance.ref().child('posts/$userId/${DateTime.now().millisecondsSinceEpoch}');
      //   final uploadTask = storageRef.putFile(_selectedImage!);
      //
      //   // Get the download URL once the upload is complete
      //   final snapshot = await uploadTask.whenComplete(() {});
      //   final downloadUrl = await snapshot.ref.getDownloadURL();
      //
      //   //  download URL
      //   print('Image uploaded! Download URL: $downloadUrl');
      // }
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
                  width: 0.6,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0), // Adjust the padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Add pictures and videos',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: w*0.4),
                InkWell(
                  onTap: _selectImage,
                  child: Icon(Icons.add_box_outlined, size: 24.0),
                ),
              ],
            ),
            SizedBox(height: h*0.02),
            Container(
              decoration: BoxDecoration(

                border: Border.all(
                  color: Colors.black,
                  width: 0.2,
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
                          Icon(Icons.pets, size: 24.0),
                          SizedBox(width: 4.0),
                          Text('Please choose an image'),
                        ],
                      ),
                    ),
                ],
              ),
            ),


            SizedBox(height: h*0.02),
            TextField(
              decoration: InputDecoration(hintText: 'Enter a caption..'),
            ),
            SizedBox(height: h*0.02), // Adjust the vertical spacing between text fields
            TextField(
              decoration: InputDecoration(hintText: 'Add location'),
            ),
            SizedBox(height: h*0.02),
            TextField(
              decoration: InputDecoration(hintText: 'Tag your buddies'),
            ),
            SizedBox(height: 16),
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

    );
  }
}
