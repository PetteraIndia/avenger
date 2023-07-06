import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 50, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: h * .2,
                color: Colors.blue,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: w * 0.1, right: w * 0.06),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Add your button's functionality here
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.27,
                    ),
                    Center(
                      child: Text(
                        'Dipendra',
                        style: TextStyle(
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Jumping fences and annoying maya is my definition of living life, woof',
                        style: TextStyle(
                          fontSize: w * 0.035,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                        maxLines:
                            2, // Set the desired number of lines or use null for unlimited lines
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '28',
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Posts',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: w * 0.02), // Adjust the spacing as needed
                        Container(
                          height: h * 0.05,
                          width: w * 0.005,
                          color: Colors.black,
                        ),
                        SizedBox(
                            width: w * 0.02), // Adjust the spacing as needed
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '931',
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Buddies',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: w * 0.02), // Adjust the spacing as needed
                        Container(
                          height: h * 0.05,
                          width: w * 0.005,
                          color: Colors.black,
                        ),
                        SizedBox(
                            width: w * 0.02), // Adjust the spacing as needed
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '712',
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Container(
                        height: h * 0.001, width: w * 1, color: Colors.black),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text(
                            'Posts',
                            style: TextStyle(
                              fontSize: w * 0.035, // Set the desired font size
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Stamp Book',
                            style: TextStyle(
                              fontSize: w * 0.035, // Set the desired font size
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Community',
                            style: TextStyle(
                              fontSize: w * 0.035, // Set the desired font size
                            ),
                          ),
                        ),
                      ],
                    ),
                    // GridView.builder(
                    //   itemCount: 5,
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2, // Number of posts per row
                    //     crossAxisSpacing:
                    //         10.0, // Spacing between posts horizontally
                    //     mainAxisSpacing:
                    //         10.0, // Spacing between posts vertically
                    //   ),
                    //   itemBuilder: (context, index) {
                    //     return Container(
                    //       width: w * 0.5,
                    //       height: h * 0.2,
                    //       color: Colors.amber,
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: h * 0.03,
              left: w * 0.25,
              right: w * 0.25,
              child: Container(
                height: h * .3,
                width: w * 0.7,
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: w * 0.2,
                      backgroundImage: AssetImage('img/sampleProfilePic.png'),
                    ),
                    Positioned(
                      top: h * 0.21,
                      left: w * 0.25,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: w * 0.06,
                      ),
                    ),
                    Positioned(
                      top: h * 0.08,
                      left: w * 0.35,
                      child: CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: w * 0.06,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
