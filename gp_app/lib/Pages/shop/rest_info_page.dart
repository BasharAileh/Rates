import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Menu_Page.dart';

class rest_info_page extends StatefulWidget {
  const rest_info_page({super.key});

  @override
  State<rest_info_page> createState() => _rest_info_pageState();
}

class _rest_info_pageState extends State<rest_info_page> {
  final AppLinks _appLinks = AppLinks();

  void _launchAppLink(String url) async {
    try {
      await _appLinks.openAppLink(Uri.parse(url));
    } catch (e) {
      print('Could not launch $url: $e');
    }
  }

  final List<String> imgList = [
    'assets/images/testpic/babalyamen.jpg',
    'assets/images/testpic/raizmalee.jpg',
    'assets/images/testpic/babalyamen.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("View Details"),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Slider Section
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
                items: imgList.map((item) => Center(
                  child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                )).toList(),
              ),
              const SizedBox(height: 16), // Add some spacing

              // Details Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Bab Eleyemen',
                            style: TextStyle(
                              fontSize: 28, // Increased font size
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Set text color to black
                            ),
                          ),
                          const SizedBox(width: 2), // Add some spacing
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.facebook, color: Colors.black, size: 24),
                            onPressed: () => _launchAppLink('https://www.facebook.com'),
                          ),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.black, size: 24),
                            onPressed: () => _launchAppLink('https://www.whatsapp.com'),
                          ),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.instagram, color: Colors.black, size: 24),
                            onPressed: () => _launchAppLink('https://www.instagram.com'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.black, size: 24),
                            onPressed: () => _launchAppLink('https://www.example.com'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Increased spacing
                      const Text(
                        'Yemeni food',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black, // Set text color to black
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Information Section
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.rankingStar, color: Color.fromARGB(255, 0, 0, 0), size: 24), // Increased icon size
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "1st Place",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black, // Set text color to black
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _launchAppLink('geo:0,0?q=Jordan+University+St'), // Replace with your location URL
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.place_outlined, color: Color.fromARGB(255, 0, 0, 0), size: 24), // Increased icon size
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Jordan University St.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black, // Set text color to black
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _launchAppLink('tel:0798086423'), // Replace with your phone number
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.phone_outlined, color: Color.fromARGB(255, 0, 0, 0), size: 24), // Increased icon size
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '0798086423',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black, // Set text color to black
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.access_time_outlined, color: Color.fromARGB(255, 0, 0, 0), size: 24), // Increased icon size
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '10 AM - 11 PM',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black, // Set text color to black
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.delivery_dining_outlined, color: Color.fromARGB(255, 0, 0, 0), size: 24), // Increased icon size
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Careem - Talabat',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black, // Set text color to black
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.card_giftcard_outlined, color: Color.fromARGB(255, 0, 0, 0), size: 24), // Increased icon size
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'No Vouchers exist currently',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black, // Set text color to black
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.attach_money_outlined, color: Color.fromARGB(255, 0, 0, 0), size: 24), // Increased icon size
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '\$\$\$\$',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black, // Set text color to black
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spacer to push the button to the bottom
                      const Spacer(),

                      // Menu Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MenuPage()),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            child: Text(
                              'Menu',
                              style: TextStyle(color: Colors.white, fontSize: 18), // Increased font size
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Positioned Container
          Positioned(
            top: 208, // Adjust the position as needed
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: screenWidth / 1.5, // Set the width to half of the screen width
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Center(
                  child: Text(
                    '3.4 Stars | 300+ Reviews',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Increased font size
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            label: 'Rate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}

extension on AppLinks {
  openAppLink(Uri parse) {}
}