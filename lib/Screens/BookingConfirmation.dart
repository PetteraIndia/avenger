import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'BookingConfirmed.dart';

class BookingConfirmation extends StatelessWidget {
  final String animal;
  final String location;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String address;
  final String type;
  final String price;
  final String name;
  final String serviceprovidercontact;

  BookingConfirmation({
    required this.animal,
    required this.location,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.type,
    required this.price,
    required this.name,
    required this.serviceprovidercontact,
  });

  String userId = FirebaseAuth.instance.currentUser!.uid;
  String createOrder() {
    String userUid = FirebaseAuth.instance.currentUser!
        .uid; // Replace this with your actual user UID logic.
    int randomNumber = Random().nextInt(10000000);
    return userUid + randomNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String username = '';
    String userContact = '';

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        username = data?['Username'] ?? '';
        userContact = data?['phone'] ?? '';
      } else {
        print('User document does not exist.');
      }
    }).catchError((error) {
      print('Error fetching user data: $error');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Confirmation'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.pop(context); // Go back when back button is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildConfirmationItem(
                'Service:',
                Text(
                  type,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Animal:',
                Text(
                  animal,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Location:',
                Text(
                  location,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Address:',
                Text(
                  address,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
              'Time Slot:',
              Text(
                '${DateFormat('yyyy-MM-dd').format(selectedDate)} at ${selectedTime.format(context)}',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Billing Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Amount:',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Rs $price',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount:',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Rs 0',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Divider(
              // Horizontal line to separate sections
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'To Pay:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // Calculate and display the difference of order amount and discount
                Text(
                  "Rs $price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFF07203F),
        ),
        child: Center(
          child: FloatingActionButton.extended(
            label: Text(
              'Book Now',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pay Now'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.money),
                          title: Text('Pay with Cash'),
                          onTap: () async {
                            String orderId = createOrder();

                            // Store the data in Firestore
                            await FirebaseFirestore.instance
                                .collection('orders')
                                .doc(orderId)
                                .set({
                              'animal': animal,
                              'selectedDate': selectedDate,
                              'selectedTime': selectedTime.toString(),
                              'location': location,
                              'type': type,
                              'price': price,
                              'address': address,
                              'orderId': orderId,
                              'name': name,
                              'datePublished': now.toUtc(),
                            });
                            await FirebaseFirestore.instance
                                .collection('usersdata')
                                .doc(userId)
                                .collection('orders')
                                .doc(orderId)
                                .set({
                              'animal': animal,
                              'selectedDate': selectedDate,
                              'selectedTime': selectedTime.toString(),
                              'location': location,
                              'type': type,
                              'price': price,
                              'address': address,
                              'orderId': orderId,
                              'name': name,
                              'datePublished': now.toUtc(),
                            }).then((_) async {
                              await sendCustomMessage(
                                date: DateFormat('yyyy-MM-dd')
                                    .format(selectedDate),
                                location: address,
                                name: username,
                                orderId: orderId,
                                serviceProviderContact:
                                    '91' + serviceprovidercontact,
                                time: selectedTime.toString(),
                                userContact: userContact,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingConfirmed(
                                    animal: animal!,
                                    location: location!,
                                    selectedDate: selectedDate!,
                                    selectedTime: selectedTime!,
                                    address: address,
                                    type: type,
                                    price: price,
                                    orderId: orderId,
                                  ),
                                ),
                              );
                            }).catchError((error) {
                              // Handle any errors that occur during data storage.
                              print("Error storing data: $error");
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildConfirmationItem(String heading, Widget content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          child: Text(
            heading,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 8),
        Expanded(child: content),
      ],
    );
  }
}

// Future<void> sendCustomMessage({
//   required String name,
//   required String serviceProviderContact,
//   required String orderId,
//   required String date,
//   required String time,
//   required String location,
//   required String userContact,
// }) async {
//   final String apiUrl =
//       'https://graph.facebook.com/v17.0/115655814950394/messages';
//   final String accessToken =
//       'EAAfqFTnxC0IBO4k1OxYZB6Ee5mQQmMeMydyl0xqtqAO6KZCIXCu2EXco6q3HqvDI6L0NiadGrbgSxp5CCBMU3bHurZBUk7exNbNk2VFQnoGJc0ZAFmvi1beesLEnlJqXq1zZCZCVdPB6QgOAUE2EUIAslUvIrirTFXh5NhvAV63ZB7K5TTJtDeZCE4ynnGqtB5trCXcUJ5qzCXbi3ezE';

//   final Map<String, dynamic> messageData = {
//     "messaging_product": "whatsapp",
//     "to":
//         serviceProviderContact, // Replace with the recipient's phone number in E.164 format.
//     "type": "text", // Use 'text' for a simple text message.
//     "text": {
//       "preview_url": false,
//       "body":
//           "this is hariom from pettera testing cloud messaging  Your service hase been booked by $name ,, order id : $orderId ,, date : $date ,, time : $time ,, contact : $userContact ,, at location : $location",
//     }
//   };

//   final headers = {
//     'Authorization': 'Bearer $accessToken',
//     'Content-Type': 'application/json',
//   };

//   final response = await http.post(Uri.parse(apiUrl),
//       headers: headers, body: jsonEncode(messageData));

//   if (response.statusCode == 200) {
//     print('Message sent successfully!');
//   } else {
//     print('Failed to send message. Status code: ${response.statusCode}');
//     print('Response body: ${response.body}');
//   }
// }

Future<void> sendCustomMessage({
  required String name,
  required String serviceProviderContact,
  required String orderId,
  required String date,
  required String time,
  required String location,
  required String userContact,
}) async {
  final String apiUrl =
      'https://graph.facebook.com/v17.0/115655814950394/messages';
  final String accessToken =
      'EAAfqFTnxC0IBO4k1OxYZB6Ee5mQQmMeMydyl0xqtqAO6KZCIXCu2EXco6q3HqvDI6L0NiadGrbgSxp5CCBMU3bHurZBUk7exNbNk2VFQnoGJc0ZAFmvi1beesLEnlJqXq1zZCZCVdPB6QgOAUE2EUIAslUvIrirTFXh5NhvAV63ZB7K5TTJtDeZCE4ynnGqtB5trCXcUJ5qzCXbi3ezE';

  final Map<String, dynamic> messageData = {
    "messaging_product": "whatsapp",
    "recipient_type": "individual",
    "to": serviceProviderContact,
    "type": "template",
    "template": {
      "name": "serviceprovider", // Replace with your template name.
      "language": {
        "code": "en_US" // Replace with the language code.
      },
      "components": [
        {
          "type": "body",
          "parameters": [
            {"type": "text", "text": name},
            {"type": "text", "text": date},
            {"type": "text", "text": time},
            {"type": "text", "text": location},
            {"type": "text", "text": orderId},
            {"type": "text", "text": userContact}
          ]
        }
      ]
    }
  };

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  final response = await http.post(Uri.parse(apiUrl),
      headers: headers, body: jsonEncode(messageData));

  if (response.statusCode == 200) {
    print('Message sent successfully!');
  } else {
    print('Failed to send message. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
