import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:petterav1/Screens/serviceProvider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final List<Map<String, String>> avatarsData = [
    {
      'imagePath': 'serviceImg/petParties.png',
      'sampleText': 'Pet Parties',
      'serviceName': 'petparties',
    },
    {
      'imagePath': 'serviceImg/dental.png',
      'sampleText': 'Pet Dental',
      'serviceName': 'petparties',
    },
    {
      'imagePath': 'serviceImg/nutritionist.png',
      'sampleText': 'Pet Nutritionist',
      'serviceName': 'petnutritionist',
    },
    {
      'imagePath': 'serviceImg/vets.png',
      'sampleText': 'Pet Vets',
      'serviceName': 'petvets',
    },
    {
      'imagePath': 'serviceImg/petParties.png',
      'sampleText': 'Pet Parties',
      'serviceName': 'petparties',
    },
    {
      'imagePath': 'serviceImg/petParties.png',
      'sampleText': 'Pet Parties',
      'serviceName': 'petparties',
    },
  ];

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
                                hintText: 'Search for services',
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
                'Service for you',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.05,
                ),
              ),
              SizedBox(height: w * 0.05),
              SizedBox(
                height: 120.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: avatarsData.length,
                  itemBuilder: (context, index) {
                    Map<String, String> avatarData = avatarsData[index];

                    return Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: CircularAvatarWithText(
                        imagePath: avatarData['imagePath']!,
                        sampleText: avatarData['sampleText']!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceProviderScreen(
                                  serviceName: avatarData['serviceName']!),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: w * 0.05),
              SizedBox(
                height: 120.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: avatarsData.length,
                  itemBuilder: (context, index) {
                    Map<String, String> avatarData = avatarsData[index];

                    return Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: CircularAvatarWithText(
                        imagePath: avatarData['imagePath']!,
                        sampleText: avatarData['sampleText']!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceProviderScreen(
                                  serviceName: avatarData['serviceName']!),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: w * 0.05),
              Text(
                'Offers for you',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.05,
                ),
              ),
              SizedBox(
                height: w * 0.5,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: w * 0.5,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                  items: [
                    Image.asset('serviceImg/Offer1.png'),
                    Image.asset('serviceImg/Offer2.png'),
                    Image.asset('serviceImg/Offer3.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularAvatarWithText extends StatelessWidget {
  final String imagePath;
  final String sampleText;
  final VoidCallback? onTap;

  const CircularAvatarWithText({
    required this.imagePath,
    required this.sampleText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(
              imagePath,
              width: w * 0.2,
              height: w * 0.2,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            sampleText,
            style: TextStyle(
              fontSize: w * 0.032,
            ),
          ),
        ],
      ),
    );
  }
}
