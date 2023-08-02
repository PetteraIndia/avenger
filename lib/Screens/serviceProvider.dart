import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petterav1/Screens/serviceMenu.dart';
import '../Widgets/serviceWidget.dart';

class ServiceProviderScreen extends StatefulWidget {
  final String serviceName;

  const ServiceProviderScreen({required this.serviceName});

  @override
  _ServiceProviderScreenState createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  bool _locationPermissionChecked = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    if (!_locationPermissionChecked) {
      _locationPermissionChecked = true;
      if (await Geolocator.isLocationServiceEnabled()) {
        if (await Geolocator.checkPermission() == LocationPermission.denied) {
          await Geolocator.requestPermission();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.1, w * 0.04, w * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: w * 0.05),
              Text(
                'Pet Service Providers',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.06,
                ),
              ),
              SizedBox(height: w * 0.03),
              // Use StreamBuilder to fetch data and build the list of cards
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('services')
                    .doc('allservices')
                    .collection(widget.serviceName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    List<DocumentSnapshot> dataList = snapshot.data!.docs;
                    if (dataList.isEmpty) {
                      // Display a message when there are no service providers available
                      return Center(
                        child: Text('No Service Provider Available'),
                      );
                    } else {
                      return Column(
                        children: dataList.map((doc) {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to the ServiceDetailsScreen when the card is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServiceDetailsScreen(
                                      serviceProviderName: data['name'],
                                      serviceName: widget.serviceName,
                                      imageUrl: data['imageUrl'],
                                      rating: data['rating'],
                                      serviceId: doc.id,
                                      location: data['location'],
                                      locality: data['locality'],
                                      specialisation: data['specialisation'],
                                    ),
                                  ),
                                );
                              },
                              child: ServiceCard(
                                name: data['name'],
                                locality: data['locality'],
                                specialisation: data['specialisation'],
                                approx: data['approx'],
                                rating: data['rating'],
                                imageUrl: data['imageUrl'],
                                location: data['location'],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  } else {
                    // Display a message when there's an error fetching data
                    return Center(
                      child: Text('Error fetching data'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
