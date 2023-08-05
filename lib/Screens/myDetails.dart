import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class MyDetailsPage extends StatefulWidget {
  final String userId;

  const MyDetailsPage({super.key, required this.userId});

  @override
  _MyDetailsPageState createState() => _MyDetailsPageState();
}

class _MyDetailsPageState extends State<MyDetailsPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _detailsFetched = false;
  String? _address;
  String? _phone;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    print('User ID: ${widget.userId}');
  }

  void _fetchUserDetails() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (userSnapshot.exists) {
        setState(() {
          _address = userSnapshot.get('address');
          _phone = userSnapshot.get('phone');
          _detailsFetched = true;
          _addressController.text = _address ?? '';
          _phoneController.text = _phone ?? '';
        });
      } else {
        setState(() {
          _detailsFetched = true;
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        _detailsFetched = true;
      });
    }
  }

  void _updateUserDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'address': _addressController.text,
        'phone': _phoneController.text,
      });
      setState(() {
        _address = _addressController.text;
        _phone = _phoneController.text;
      });
      Navigator.pop(context); // Close the edit dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Details saved successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error updating user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Details'),
      ),
      body: _detailsFetched
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Address:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _address != null ? _address! : 'Address not available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Phone:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _phone != null ? _phone! : 'Phone number not available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Edit Address and Phone'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _addressController,
                                  decoration: const InputDecoration(
                                    labelText: 'Address',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _updateUserDetails();
                                  Navigator.pop(context);
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: const Text('Edit Details'),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
