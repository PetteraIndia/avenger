import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Resources extends StatefulWidget {
  const Resources({Key? key}) : super(key: key);

  @override
  State<Resources> createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  List<QueryDocumentSnapshot>? _resources;
  late List<bool> _isExpandedList;
  late List<bool> _isTextTappedList;

  @override
  void initState() {
    super.initState();
    _isExpandedList = [];
    _isTextTappedList = [];
    fetchResources();
  }

  Future<void> fetchResources() async {
    final resourcesSnapshot =
        await FirebaseFirestore.instance.collection('resources').get();

    setState(() {
      _resources = resourcesSnapshot.docs;
      _isExpandedList = List.generate(_resources!.length, (index) => false);
      _isTextTappedList = List.generate(_resources!.length, (index) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    if (_resources == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: _resources!.length + 1,
        itemBuilder: (context, index) {
          if (index == _resources?.length) {
            // Render the empty container
            return Container(height: screenHeight * 0.1);
          }
          final resource = _resources?[index];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isTextTappedList[index]
                ? null // Allow the height to expand to fit the content
                : _isExpandedList[index]
                    ? screenHeight * 0.3 // Expanded height when icon is pressed
                    : screenHeight * 0.1, // Collapsed height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenHeight * 0.02),
              color: const Color(0xFFFDF0AC),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.1, // Fixed height for the row
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isTextTappedList[index] =
                                  !_isTextTappedList[index];
                            });
                          },
                          child: Text(
                            resource?['name'], // Name of the resource
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (!_isTextTappedList[index]) {
                            setState(() {
                              _isExpandedList[index] = !_isExpandedList[index];
                            });
                          }
                        },
                        icon: Icon(_isExpandedList[index]
                            ? Icons.keyboard_arrow_up
                            : Icons.info_outline),
                      ),
                    ],
                  ),
                ),
                if (_isTextTappedList[index])
                  FutureBuilder<QuerySnapshot>(
                    future: resource?.reference.collection('data').get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error'),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('No data available'),
                        );
                      } else {
                        final dataDocuments = snapshot.data!.docs;

                        return Container(
                          height: screenHeight *
                              0.59, // Calculate the available height for the list
                          child: ListView.builder(
                            itemCount: dataDocuments.length,
                            itemBuilder: (context, subIndex) {
                              final dataDocument = dataDocuments[subIndex];

                              return Container(
                                width: screenWidth * 0.87,
                                height: screenHeight * 0.3,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFF07203F),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 8, right: 8),
                                      child: Text(
                                        dataDocument['name'],
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Text(
                                        'Contact: ${dataDocument['contact']}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Text(
                                        'Address: ${dataDocument['address']}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Text(
                                        'Cost: ${dataDocument['cost']}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Text(
                                        'Notes: ${dataDocument['notes']}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Text(
                                              'Contact',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '|',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 40),
                                            child: GestureDetector(
                                              onTap: () {
                                                String url =
                                                    'https://www.google.com/maps/place/${dataDocument['address']}';
                                                launchUrlString(
                                                    url); // Launch the URL in a browser
                                              },
                                              child: Text(
                                                'Location',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                if (_isExpandedList[index] && !_isTextTappedList[index])
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        resource?[
                            'about'], // Text from the 'about' field in the resource document
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
