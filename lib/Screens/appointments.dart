import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../resources/auth_methods.dart';
import 'BookingConfirmed.dart';

class Appointments extends StatefulWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: _buildAppointmentsList(),
    );
  }

  Widget _buildAppointmentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('usersdata')
          .doc(userId)
          .collection('orders')
          .orderBy('datePublished',
              descending: true) // Sort by datePublished in descending order
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final appointment = documents[index];
              final type = appointment['type'];
              final orderId = appointment['orderId'];
              final price = appointment['price'];
              final selectedDate = appointment['selectedDate'];
              final selectedTime = appointment['selectedTime'];
              final name = appointment['name'];
              final animal = appointment['animal'];
              final location = appointment['location'];
              final address = appointment['address'];

              return CardWidget(
                type: type,
                orderId: orderId,
                price: price,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                name: name,
                animal: animal,
                location: location,
                address: address,
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Error fetching data');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final String type;
  final String orderId;
  final String price;
  final Timestamp selectedDate;
  final String selectedTime;
  final String name;
  final String animal;
  final String location;
  final String address;

  const CardWidget({super.key, 
    required this.type,
    required this.orderId,
    required this.price,
    required this.selectedDate,
    required this.selectedTime,
    required this.name,
    required this.animal,
    required this.location,
    required this.address,
  });

  bool _isAppointmentCompleted(Timestamp selectedDate, String selectedTime) {
    DateTime now = DateTime.now();
    DateTime appointmentDate = selectedDate.toDate();
    TimeOfDay appointmentTime = _parseTime(selectedTime);

    DateTime appointmentDateTime = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
      appointmentTime.hour,
      appointmentTime.minute,
    );

    return now.isAfter(appointmentDateTime);
  }

  TimeOfDay _parseTime(String time) {
    final String cleanedTime =
        time.replaceAll('TimeOfDay(', '').replaceAll(')', '');
    final List<String> components = cleanedTime.split(':');
    int hour = int.parse(components[0]);
    int minute = int.parse(components[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    String period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    int hour = timeOfDay.hourOfPeriod;
    int minute = timeOfDay.minute;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  void _updateAppointmentStatus(String orderId) {
    FirebaseFirestore.instance
        .collection('usersdata')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .update({'status': 'Completed'}).then((_) {
      print('Appointment status updated successfully');
    }).catchError((error) {
      print('Error updating appointment status: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    DateTime dateTime = selectedDate.toDate();
    TimeOfDay timeOfDay = _parseTime(selectedTime);
    String formattedTime = _formatTimeOfDay(timeOfDay);

    bool isCompleted = _isAppointmentCompleted(selectedDate, selectedTime);

    return Padding(
      padding: EdgeInsets.all(w * 0.05),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(w * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '$type at $name',
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: w * 0.02,
                  ),
                  Text(
                    '₹${price.toString()}',
                    style: TextStyle(
                        fontSize: w * 0.04, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: h * 0.02),
              Text(
                'Order #$orderId',
                style: TextStyle(
                  fontSize: w * 0.03,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: h * 0.01),
              Text(
                '${DateFormat('yyyy-MM-dd').format(dateTime)} at $formattedTime',
              ),
              SizedBox(height: h * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmed(
                            animal: animal,
                            location: location,
                            selectedDate: dateTime,
                            selectedTime: timeOfDay,
                            address: address,
                            type: type,
                            price: price,
                            orderId: orderId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Change the button color
                      foregroundColor: Colors.white, // Change the text color
                      elevation: 4, // Add elevation to the button
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24), // Adjust padding
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(fontSize: 16), // Adjust font size
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isCompleted) {
                        _updateAppointmentStatus(orderId);
                      } else {
                        // Add your "Pending" button action here
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted
                          ? Colors.green
                          : Colors.red, // Change button color
                    ),
                    child: isCompleted
                        ? const Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.white, // Change status text color
                            ),
                          )
                        : const Text(
                            'Pending',
                            style: TextStyle(
                              color: Colors.white, // Change status text color
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
