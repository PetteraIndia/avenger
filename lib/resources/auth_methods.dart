import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:petterav1/resources/storage_methods.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<File> compressImage(String imagePath) async {
  // Get the directory for saving the compressed image
  final appDir = await path_provider.getApplicationDocumentsDirectory();
  final compressedPath = '${appDir.path}/compressed_image.jpg';

  // Compress the image
  await FlutterImageCompress.compressAndGetFile(
    imagePath,
    compressedPath,
    quality: 20, // Adjust the quality level (0 to 100)
    rotate: 0, // Adjust the rotation angle (in degrees, 0 to 360)
  );

  return File(compressedPath);
}

var userId = FirebaseAuth.instance.currentUser!.uid;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> personalDetails({
    required String email,
    required String password,
    required String username,
    required String bio,
    required File? file,
    required String fullname,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          fullname.isEmpty ||
          file == null) {
        final compressedImage = await compressImage(file!.path);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', compressedImage, false);

        await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
          'Username': username,
          'Full Name': fullname,
          'uid': _auth.currentUser!.uid,
          'email': email,
          'phone': password,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
          'hasSignedInBefore': true,
        });
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Future<String> petDetails({
  //   required String petName,
  //   required String petType,
  //   required String petBreed,
  //   required String petDOB,
  //   required File? file,
  // }) async {
  //   String res = "Some error Occurred";
  //   try {
  //     if (petName.isNotEmpty ||
  //         petType.isNotEmpty ||
  //         petBreed.isNotEmpty ||
  //         petDOB.isNotEmpty ||
  //         file == null) {
  //       final compressedImage = await compressImage(file!.path);

  //       String photoUrl = await StorageMethods()
  //           .uploadPetsImageToStorage('petPics', compressedImage, false);

  //       String petId = FirebaseFirestore.instance
  //           .collection('posts')
  //           .doc(userId)
  //           .collection('pets')
  //           .doc()
  //           .id;

  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userId)
  //           .collection('pets')
  //           .doc(petId)
  //           .set({
  //         'Pet Name': petName,
  //         'Pet Type': petType,
  //         'Pet Breed': petBreed,
  //         'pet DOB': petDOB,
  //         'photoUrl': photoUrl,
  //       });

  //       res = "success";
  //     } else {
  //       res = "Please enter all the fields";
  //     }
  //   } catch (err) {
  //     return err.toString();
  //   }
  //   return res;
  // }

  Future<String> petDetails({
    required String petName,
    required String petType,
    required String petBreed,
    required String petDOB,
    required File? file,
  }) async {
    String res = "Some error occurred";
    try {
      if (petName.isNotEmpty ||
          petType.isNotEmpty ||
          petBreed.isNotEmpty ||
          petDOB.isNotEmpty ||
          file == null) {
        final compressedImage = await compressImage(file!.path);

        String photoUrl = await StorageMethods()
            .uploadPetsImageToStorage('petPics', compressedImage, false);

        // Get the current timestamp
        final Timestamp timestamp = Timestamp.now();
        String petId =
            timestamp.seconds.toString(); // Use timestamp as the document ID

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('pets')
            .doc(petId)
            .set({
          'Pet Name': petName,
          'Pet Type': petType,
          'Pet Breed': petBreed,
          'Pet DOB': petDOB,
          'PhotoUrl': photoUrl,
          'Timestamp':
              timestamp, // Store the timestamp for sorting purposes if needed
        });

        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      print('hiiiiiiiiiiiii');
      return err.toString();
    }
    print(res);
    return res;
  }
}
