import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:petterav1/Screens/socialmediapage.dart';
import 'package:petterav1/resources/auth_methods.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
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

class _EditProfileScreenState extends State<EditProfileScreen> {
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

  Future<void> uploadPersonalDetails() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().personalDetailsEdit(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image,
      fullname: _nameController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SocialMediaPage(Si: 4, ci: 0),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(res),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

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
                        const Offset(0, -20), // Adjust the vertical offset as desired
                    child: Text(
                      'Edit Personal Details',
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
                child: Column(
                  children: [
                    SizedBox(height: h * 0.3),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your Full Name",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your Username",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your Email",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _passwordController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your Phone Number",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _bioController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your Bio",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    SizedBox(height: h * 0.04),
                    if (_isLoading)
                      const CircularProgressIndicator() // Show loading indicator
                    else
                      ElevatedButton.icon(
                        icon: const Icon(Icons.person),
                        label: const Text("Submit Details"),
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
                                  title: const Text('Incomplete Entries'),
                                  content: const Text(
                                      'Please fill all the fields and Choose the Profile Pic.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
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
                                const AssetImage('img/sampleProfilePic.png'),
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
