import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, File file, bool isPost) async {
    // creating location to our firebase storage

    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    // if(isPost) {
    //   String id = const Uuid().v1();
    //   ref = ref.child(id);
    // }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadPetsImageToStorage(
      String childName, File file, bool isPost) async {
    // Creating location in our Firebase Storage
    final uid = _auth.currentUser!.uid;
    final folderName = 'petPics/$uid';
    final ref = FirebaseStorage.instance
        .ref()
        .child('$folderName/${DateTime.now().millisecondsSinceEpoch}');

    // Putting in Uint8List format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
