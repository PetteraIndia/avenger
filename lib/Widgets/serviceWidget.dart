import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ServiceCard extends StatefulWidget {
  final String name;
  final String locality;
  final String specialisation;
  final String approx;
  final String rating;
  final String imageUrl;
  final String location;

  const ServiceCard({
    required this.name,
    required this.locality,
    required this.specialisation,
    required this.approx,
    required this.rating,
    required this.imageUrl,
    required this.location,
  });

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  String distance = 'Calculating...';

  @override
  void initState() {
    super.initState();
    _calculateDistance(); // Calculate the distance when the widget initializes
  }

  Future<void> _calculateDistance() async {
    // Get the user's current location
    Position userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Get the latitude and longitude from the provided address
    List<Location> locations = await locationFromAddress(widget.location);
    double latitude = locations.first.latitude;
    double longitude = locations.first.longitude;

    // Calculate the distance between the user's location and the provided location
    double calculatedDistance = await Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      latitude,
      longitude,
    );

    setState(() {
      distance = (calculatedDistance / 1000).toStringAsFixed(2) + ' km';
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: w * 0.4,
      decoration: BoxDecoration(
        color: Color(0xFF07203F),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: 1.0,
          color: Color(0xFF07203F),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: w * 0.28,
            height: w * 0.3,
            decoration: BoxDecoration(
              color: Colors.grey, // Placeholder color until you add the image
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.all(
              10.0,
            ), // Add some margin to separate from the container edges
            // Add the image inside the small container
            child: Image.network(
              widget.imageUrl, // Replace with the actual image URL
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines:
                        1, // Show only one line and truncate with ellipsis if needed
                    overflow: TextOverflow
                        .ellipsis, // Use ellipsis to truncate long text
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        distance, // Display the calculated distance
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        ' | ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        widget.locality,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.specialisation,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Approx: ₹${widget.approx}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        ' | ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        widget.rating,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Icon(
                        Icons.star,
                        color: Colors.white,
                        size: w * 0.04, // Adjust the size as needed
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
