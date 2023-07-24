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
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      if (await Geolocator.checkPermission() == LocationPermission.denied) {
        await Geolocator.requestPermission();
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
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20.0),
                          right: Radius.circular(20.0),
                        ),
                        border: Border.all(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.search),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      // Menu icon onPressed action
                    },
                  ),
                ],
              ),
              SizedBox(height: w * 0.05),
              Text(
                'Pet Veterinarian Services',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.05,
                ),
              ),
              SizedBox(height: w * 0.02),
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
                  } else {
                    return Text('Error fetching data');
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
