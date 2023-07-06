import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petterav1/Screens/newpost.dart';
import 'package:petterav1/resources/auth_methods.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/text_field.dart';
import '../resources/storage_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import 'boarding_screen2.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image,
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
                const BoardingScreen2(), // Replace with the name of your screen
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
            Column(
              children: [
                Container(
                  height: h * .25,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Personal Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Container(
                    height: h * .75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: SafeArea(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                _image != null
                                    ? CircleAvatar(
                                        radius: 64,
                                        backgroundImage: FileImage(_image!),
                                        // backgroundColor: Colors.red,
                                      )
                                    : const CircleAvatar(
                                        radius: 64,
                                        backgroundImage: AssetImage(
                                            'img/sampleProfilePic.png'),
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
                            const SizedBox(height: 24),
                            TextFieldInput(
                              hintText: 'Enter your username',
                              textInputType: TextInputType.text,
                              textEditingController: _usernameController,
                            ),
                            const SizedBox(height: 24),
                            TextFieldInput(
                              hintText: 'Enter your email',
                              textInputType: TextInputType.emailAddress,
                              textEditingController: _emailController,
                            ),
                            const SizedBox(height: 24),
                            TextFieldInput(
                              hintText: 'Enter your password',
                              textInputType: TextInputType.text,
                              textEditingController: _passwordController,
                              isPass: true,
                            ),
                            const SizedBox(height: 24),
                            TextFieldInput(
                              hintText: 'Enter your bio',
                              textInputType: TextInputType.text,
                              textEditingController: _bioController,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(height: 16),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.blue,
                              ),
                              iconSize: 70,
                              onPressed: () {
                                if (_emailController.text.isEmpty ||
                                    _bioController.text.isEmpty ||
                                    _passwordController.text.isEmpty ||
                                    _usernameController.text.isEmpty ||
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
                                  signUpUser();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
