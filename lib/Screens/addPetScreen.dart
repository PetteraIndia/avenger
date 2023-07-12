import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petterav1/Screens/profile_screen.dart';

import '../Widgets/text_field.dart';
import '../resources/auth_methods.dart';
import 'boarding_screen1.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
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

class _AddPetScreenState extends State<AddPetScreen> {
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petBreedController = TextEditingController();
  final TextEditingController _petDOBController = TextEditingController();
  File? _image;
  bool _isLoading = false;
  String? _selectedPetType;

  @override
  void dispose() {
    super.dispose();
    _petNameController.dispose();
    _petBreedController.dispose();
    _petDOBController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedPetType =
        'Dog'; // Set initial value to the first pet type in the list
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

  Future<void> uploadPetDetails() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().petDetails(
      petName: _petNameController.text,
      petType: _selectedPetType!,
      petBreed: _petBreedController.text,
      petDOB: _petDOBController.text,
      file: _image,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == "Success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(res),
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
                        Offset(0, -20), // Adjust the vertical offset as desired
                    child: Text(
                      'Pet Detail',
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 10), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _petNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Your Pet Number",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Select Pet Type',
                            border: InputBorder
                                .none, // Remove border for DropdownButtonFormField
                          ),
                          value: _selectedPetType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPetType = newValue;
                            });
                          },
                          items: <String>[
                            'Dog',
                            'Cat',
                            'Bird',
                            'Rabbit',
                            'Hamster'
                            // Add more pet types as needed
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _petBreedController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your pet breed name",
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 10), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder
                                      .none, // Remove border for TextFormField
                                  hintText: 'Pet DOB',
                                ),
                                controller: _petDOBController,
                                readOnly: true,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () async {
                                final DateTime? selectedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (selectedDate != null) {
                                  setState(() {
                                    _petDOBController.text = selectedDate
                                        .toIso8601String()
                                        .split('T')[0];
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(height: h * 0.04),
                    if (_isLoading)
                      CircularProgressIndicator() // Show loading indicator
                    else
                      ElevatedButton.icon(
                        icon: Icon(Icons.pets),
                        label: Text("Upload Pet"),
                        onPressed: () {
                          if (_petNameController.text.isEmpty ||
                              _petDOBController.text.isEmpty ||
                              _selectedPetType == null ||
                              _petBreedController.text.isEmpty ||
                              _image == null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Incomplete Entries'),
                                  content: Text(
                                    'Please fill all the fields and choose the Profile Pic.',
                                  ),
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
                            uploadPetDetails();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(
                              16), // Increase the padding to increase the button's size
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
