import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petterav1/Screens/BookingPage.dart';

class ServiceMenuList extends StatelessWidget {
  final String serviceName;
  final String serviceId;
  final String address;
  final String serviceprovidercontact;

<<<<<<< HEAD
  const ServiceMenuList({super.key, required this.serviceName, required this.serviceId , required this.address,});
=======
  ServiceMenuList({
    required this.serviceName,
    required this.serviceId,
    required this.address,
    required this.serviceprovidercontact,
  });
>>>>>>> main

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('services')
          .doc('allservices')
          .collection(serviceName)
          .doc(serviceId)
          .collection('service')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Services Provided',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('services')
                    .doc('allservices')
                    .collection(serviceName)
                    .doc(serviceId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final doc = snapshot.data;
                    final name =
                        doc?['name'] ?? ''; // Use null safety if available

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final type = doc['type'] ?? '';
                        final price = doc['price'] ?? '';
                        final available = doc['available'] ?? false;
                        final descryption = doc['descryption'] ?? '';
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0), // Add vertical padding here
                          child: ServiceMenuWidget(
                            type: type,
                            price: price,
                            available: available,
                            descryption: descryption,
                            address: address,
                            name: name,
                            serviceprovidercontact: serviceprovidercontact,
                          ),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator(); // Or any loading widget while data is being fetched
                  }
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading data');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class ServiceMenuWidget extends StatefulWidget {
  final String type;
  final String price;
  final String available;
  final String descryption;
  final String address;
  final String name;
  final String serviceprovidercontact;

  const ServiceMenuWidget({super.key, 
    required this.type,
    required this.price,
    required this.available,
    required this.descryption,
    required this.address,
    required this.name,
    required this.serviceprovidercontact,
  });

  @override
  _ServiceMenuWidgetState createState() => _ServiceMenuWidgetState();
}

class _ServiceMenuWidgetState extends State<ServiceMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF07203F), // Set the background color to #07203F
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.type,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Price: ${widget.price}', // Display the provided price
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Available for :- ${widget.available}', // Display availability based on the provided value
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality for the "Book Now" button here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(
                        type: widget.type,
                        price: widget.price,
                        available: widget.available,
                        description: widget.descryption,
                        address: widget.address,
                        name: widget.name,
                        serviceprovidercontact: widget.serviceprovidercontact,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(
                      0xFF07203F), backgroundColor: Colors.white, // Set the text color when the button is pressed
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    color: Color(0xFF07203F), // Set the text color to #07203F
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
