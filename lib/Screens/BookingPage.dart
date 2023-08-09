import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'BookingConfirmation.dart';
import 'myDetails.dart';

class BookingPage extends StatefulWidget {
  final String type;
  final String price;
  final String available;
  final String description;
  final String address;
  final String name;


  BookingPage({
    required this.type,
    required this.price,
    required this.available,
    required this.description,
    required this.address,
    required this.name,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? animal;
  String? location;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final maxAllowedLines = (screenHeight * 0.18) ~/ 20; // Assuming each line is around 20 pixels high.

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight*0.013),
            Text(
              _truncateDescription(widget.description, maxAllowedLines),
              maxLines: maxAllowedLines,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: screenHeight*0.02),
            Text(
              'Fill in Required Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight*0.02),
            _buildSubHeading('Animal', ['Cat', 'Dog', 'Others'], onPressed: () {}),
            SizedBox(height: screenHeight*0.02),
            _buildSubHeading('Location', ['Home', 'Clinic'], onPressed: () {}),
            SizedBox(height: screenHeight*0.02),
            _buildSubHeading(
              'Date',
              [],
              icon: Icons.calendar_today,
              onPressed: _selectDate,
            ),
            SizedBox(height: screenHeight*0.006),
            selectedDate != null
                ? Text('Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}')
                : SizedBox(),
            SizedBox(height: screenHeight*0.02),
            _buildSubHeading(
              'Time',
              [],
              icon: Icons.access_time,
              onPressed: _selectTime,
            ),
            SizedBox(height: screenHeight*0.006),
            selectedTime != null
                ? Text('Selected Time: ${selectedTime!.format(context)}')
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: screenWidth * 0.5,
        height: screenHeight * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFF07203F),
        ),
        child: Center(
          child: FloatingActionButton.extended(
            onPressed: _proceedBooking,
            label: Text(
              'Proceed',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),

          ),
        ),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String _truncateDescription(String description, int maxLines) {
    final words = description.split(' ');
    if (words.length <= maxLines) {
      return description;
    } else {
      return words.take(maxLines).join(' ') + '...';
    }
  }

  Widget _buildSubHeading(String heading, List<String> options,
      {IconData? icon, required void Function() onPressed}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(  // Use Expanded to allow the heading to occupy most of the space.
              child: Text(
                heading,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (icon != null)
              GestureDetector(
                onTap: onPressed,
                child: Icon(
                  icon,
                  size: 34,
                ),
              ),
            SizedBox(width: screenWidth*0.0003), // Optional spacing between heading and icon.
          ],
        ),
        SizedBox(height: screenHeight*0.02),
        Row(
          children: options
              .map(
                (option) => GestureDetector(
              onTap: () {
                setState(() {
                  if (heading == 'Animal') {
                    animal = option;
                  } else if (heading == 'Location') {
                    location = option;
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (heading == 'Animal' && animal == option) ||
                        (heading == 'Location' && location == option)
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
                child: Text(option),
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }


  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _proceedBooking() async {
    String currentUserId= FirebaseAuth.instance.currentUser!.uid;
    if (animal == null || location == null || selectedDate == null || selectedTime == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select all fields (Animal, Location, Date, and Time).'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
      String userAddress = userSnapshot.get('address') ?? "";

      if (userAddress == "Address not added" && location=="Home") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Address not found'),
              content: Text('Please add your address before proceeding.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyDetailsPage(userId: currentUserId),
                    ),
                  ),
                  child: Text('Add Address'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Back'),
                ),
              ],
            );
          },
        );
      } else if(userAddress != "Address not added" && location=="Home"){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Your Address'),
              content: Text('Address: $userAddress'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingConfirmation(
                        animal: animal!,
                        location: location!,
                        selectedDate: selectedDate!,
                        selectedTime: selectedTime!,
                        address: userAddress,
                        type: widget.type,
                        price: widget.price,
                        name: widget.name,
                      ),
                    ),
                  ),
                  child: Text('Proceed'),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyDetailsPage(userId: currentUserId),
                    ),
                  ),
                  child: Text('Edit Address'),
                ),
              ],
            );
          },
        );
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmation(
              animal: animal!,
              location: location!,
              selectedDate: selectedDate!,
              selectedTime: selectedTime!,
              address: widget.address,
              type: widget.type, price: widget.price,
              name: widget.name,
            ),
          ),
        );
      }
    }
  }


}
