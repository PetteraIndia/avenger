import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petterav1/Screens/newpost.dart';
import 'package:petterav1/Screens/socialmediapage.dart';
import 'package:petterav1/resources/auth_methods.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/text_field.dart';
import '../resources/storage_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import 'boarding_screen2.dart';

class BoardingScreen1 extends StatefulWidget {
  const BoardingScreen1({super.key});

  @override
  State<BoardingScreen1> createState() => _BoardingScreen1State();
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 50, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class _BoardingScreen1State extends State<BoardingScreen1> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  File? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
  }

  void uploadPersonalDetails() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().personalDetails(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image,
      fullname: _nameController.text,
    );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                SocialMediaPage(), // Replace with the name of your screen
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final im = await picker.pickImage(source: ImageSource.gallery);

    if (im != null) {
      setState(() {
        _image = File(im.path);
      });
    }
  }

  bool isLoadingg = false;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: h * .25,
                color: Colors.blue,
                child: Center(
                  child: Transform.translate(
                    offset:
                        Offset(0, -20), // Adjust the vertical offset as desired
                    child: Text(
                      'Personal Details',
                      style: TextStyle(
                        fontSize: w * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                width: double.infinity,
                child: Positioned(
                  child: Container(
                    height: h,
                    child: Column(
                      children: [
                        SizedBox(height: h * 0.3),
                        TextFieldInput(
                          hintText: 'Enter your Full Name',
                          textInputType: TextInputType.text,
                          textEditingController: _nameController,
                        ),
                        SizedBox(height: h * 0.02),
                        TextFieldInput(
                          hintText: 'Enter your Username',
                          textInputType: TextInputType.text,
                          textEditingController: _usernameController,
                        ),
                        SizedBox(height: h * 0.02),
                        TextFieldInput(
                          hintText: 'Enter your Email',
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _emailController,
                        ),
                        SizedBox(height: h * 0.02),
                        TextFieldInput(
                          hintText: 'Enter your Phone Number',
                          textInputType: TextInputType.number,
                          textEditingController: _passwordController,
                        ),
                        SizedBox(height: h * 0.02),
                        TextFieldInput(
                          hintText: 'Enter your Bio',
                          textInputType: TextInputType.text,
                          textEditingController: _bioController,
                        ),
                        SizedBox(height: h * 0.02),
                        SizedBox(height: h * 0.04),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.blue,
                          ),
                          iconSize: w * 0.2,
                          onPressed: () {
                            if (_emailController.text.isEmpty ||
                                _bioController.text.isEmpty ||
                                _passwordController.text.isEmpty ||
                                _usernameController.text.isEmpty ||
                                _nameController.text.isEmpty ||
                                _image == null) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Incomplete Entries'),
                                    content: Text(
                                        'Please fill all the fields and Choose the Profile Pic.'),
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
                              uploadPersonalDetails();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: h * 0.14,
              left: w * 0.3,
              right: w * 0.3,
              child: Container(
                height: h * .15,
                width: w * .4,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: w * 0.4,
                            backgroundImage: FileImage(_image!),
                            // backgroundColor: Colors.red,
                          )
                        : CircleAvatar(
                            radius: w * 0.4,
                            backgroundImage:
                                AssetImage('img/sampleProfilePic.png'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
