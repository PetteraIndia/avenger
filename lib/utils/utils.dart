import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// for picking up image from gallery

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
