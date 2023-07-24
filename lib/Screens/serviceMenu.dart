import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/serviceMenuWidget.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceProviderName;
  final String serviceName;
  final String imageUrl;
  final String rating;
  final String serviceId;
  final String location;
  final String locality;
  final String specialisation;

  ServiceDetailsScreen({
    required this.serviceProviderName,
    required this.serviceName,
    required this.imageUrl,
    required this.rating,
    required this.serviceId,
    required this.location,
    required this.locality,
    required this.specialisation,
  });

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Menu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: w,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.serviceProviderName,
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.specialisation,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Text(
                                'Rating: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '${widget.rating}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.star,
                                color: Colors.black,
                                size: w * 0.04,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Text(
                                'Locality: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '${widget.locality}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Address: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${widget.location}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: w * 0.02),
                          TextButton(
                            onPressed: () {
                              String url =
                                  'https://www.google.com/maps/place/${widget.location}';
                              launchUrlString(url);
                            },
                            child: Text(
                              'View on map',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: w * 0.28,
                    height: w * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(
                      10.0,
                    ),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: w * 0.02),
            ServiceMenuList(
              serviceName: widget.serviceName,
              serviceId: widget.serviceId,
            ),
          ],
        ),
      ),
    );
  }
}
