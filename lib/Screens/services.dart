import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServicesScreen(),
    );
  }
}

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
    },
    {
      'imagePath': 'serviceImg/dental.png',
      'sampleText': 'Pet Dental',
    },
    {
      'imagePath': 'serviceImg/nutritionist.png',
      'sampleText': 'Pet Nutritionist',
    },
    {
      'imagePath': 'serviceImg/vets.png',
      'sampleText': 'Pet Vets',
    },
    {
      'imagePath': 'serviceImg/petParties.png',
      'sampleText': 'Pet Parties',
    },
    {
      'imagePath': 'serviceImg/petParties.png',
      'sampleText': 'Pet Parties',
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
                height: w * 0.5, // Adjust the height as needed
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: w * 0.5, // Adjust the height as needed
                    aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                  items: [
                    // Add your offer banners here as Image widgets
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

  const CircularAvatarWithText({
    required this.imagePath,
    required this.sampleText,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Column(
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

            // You can also add more text styles if needed, e.g., fontWeight, color, etc.
          ),
        ),
      ],
    );
  }
}
