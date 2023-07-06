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
    quality: 90, // Adjust the quality level (0 to 100)
    rotate: 0, // Adjust the rotation angle (in degrees, 0 to 360)
  );

  return File(compressedPath);
}

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
        // registering user in auth with email and password
        // UserCredential cred = await _auth.createUserWithEmailAndPassword(
        //   email: email,
        //   password: password,
        // );

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
}
