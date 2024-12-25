import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'menu_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rates/dialogs/nav_bar.dart';

class rest_info_page extends StatefulWidget {
  const rest_info_page({super.key});

  @override
  State<rest_info_page> createState() => _rest_info_pageState();
}

class _rest_info_pageState extends State<rest_info_page> {
  final List<String> imgList = [
    'assets/images/testpic/babalyamen.jpg',
    'assets/images/testpic/babalyamen.jpg',
    'assets/images/testpic/babalyamen.jpg',
  ];

Future<void> _launchUrl(String input) async {
  final uri = Uri.tryParse(input);
  if (uri != null) {
    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      await launchUrl(
        uri,
        mode: input.startsWith('tel:') ? LaunchMode.platformDefault : LaunchMode.externalApplication, // Use platform default for phone numbers
      );
    } else {
      print('Cannot launch $input');
      throw 'Could not launch $input';
    }
  } else {
    print('Invalid input: $input');
    throw 'Invalid input: $input';
  }
}
 

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Restaurant information"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Image Slider Section
          CarouselSlider(
            options: CarouselOptions(
               aspectRatio: 100/40,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            items: imgList.map((item) => Flexible(
              flex: 10,
              child: Center(
                child: Image.asset(item, fit: BoxFit.cover, width: screenHeight, height: screenHeight*0.40),
              ),
            )).toList(),
          ),
          // Positioned Container for Rating
          Stack(
            children: [ Transform.translate(
              offset: Offset(0.0, -screenHeight*0.06 / 2.0),
              child: Container(
                width: screenWidth *0.595,
                height: screenHeight*0.06, // Set the width to half of the screen width
                decoration: BoxDecoration(
                  color: Color(0xFFF3C623)
,
                  borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
                ),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.002),
                child: Center(
                  child: Text(
                    '3.4 Stars | 300+ Reviews',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:  screenHeight/40// Responsive font size
                    ),
                  ),
                ),
              ),
            ),
            ],
          ),
          // Details Section
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Bab Eleyemen',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Set text color to black
                      ),
                    
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: SvgPicture.asset(
                                  "assets/icons/facebook.svg",
                                  width: screenWidth * 0.06, // Responsive icon size
                                  height: screenWidth * 0.06, // Responsive icon size
                                ),
                                onPressed: () => _launchUrl('https://www.facebook.com/share/1BcaP3Xsdz/?mibextid=wwXIfr'),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: SvgPicture.asset(
                                  "assets/icons/whatsapp.svg",
                                  width: screenWidth * 0.06, // Responsive icon size
                                  height: screenWidth * 0.06, // Responsive icon size
                                ),
                                onPressed: () => _launchUrl('https://www.youtube.com/'),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: SvgPicture.asset(
                                  "assets/icons/instagram.svg",
                                  width: screenWidth * 0.05, // Responsive icon size
                                  height: screenWidth * 0.05, // Responsive icon size
                                ),
                                onPressed: () => _launchUrl('https://www.instagram.com'),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: SvgPicture.asset(
                                  "assets/icons/favorite_icon.svg",
                                  width: screenWidth * 0.06, // Responsive icon size
                                  height: screenWidth * 0.06, // Responsive icon size
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                Text(
                  'Yemeni food',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    color: Colors.black, // Set text color to black
                  ),
                ),
                
                    
                // Information Section
               Column(
                 children: [
                  SizedBox(height: screenHeight * 0.01),
                   Row(
                     children: [
                       Icon(FontAwesomeIcons.rankingStar, color: const Color.fromARGB(255, 0, 0, 0), size: screenWidth * 0.06), // Increased icon size
                       SizedBox(width: screenWidth * 0.03),
                       Expanded(
                         child: Text(
                           "1st Place",
                           style: TextStyle(
                             fontSize: screenWidth *  0.045,
                             color: Colors.black, // Set text color to black
                           ),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: screenHeight * 0.01),
                   GestureDetector(
                     onTap: () => _launchUrl('geo:0,0?q=Jordan+University+St'), // Replace with your location URL
                     child: Row(
                       children: [
                         Icon(Icons.place_outlined, color: const Color.fromARGB(255, 0, 0, 0), size:  screenWidth * 0.06), // Increased icon size
                         SizedBox(width: screenWidth * 0.03),
                         Expanded(
                           child: Text(
                             'Jordan University St.',
                             style: TextStyle(
                               fontSize: screenWidth * 0.045,
                               color: Colors.black, // Set text color to black
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: screenHeight * 0.01),
                   GestureDetector(
                     onTap: () => _launchUrl('tel:0798086423'), // Replace with your phone number
                     child: Row(
                       children: [
                         Icon(Icons.phone_outlined, color: const Color.fromARGB(255, 0, 0, 0), size: screenWidth * 0.06), // Increased icon size
                         SizedBox(width: screenWidth * 0.03),
                         Expanded(
                           child: Text(
                             '0798086423',
                             style: TextStyle(
                               fontSize: screenWidth *  0.045,
                               color: Colors.black, // Set text color to black
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: screenHeight * 0.01),
                   Row(
                     children: [
                       Icon(Icons.access_time_outlined, color: const Color.fromARGB(255, 0, 0, 0), size: screenWidth * 0.06), // Increased icon size
                       SizedBox(width: screenWidth * 0.03),
                       Expanded(
                         child: Text(
                           '10 AM - 11 PM',
                           style: TextStyle(
                             fontSize: screenWidth *  0.045,
                             color: Colors.black, // Set text color to black
                           ),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: screenHeight * 0.01),
                   Row(
                     children: [
                       Icon(Icons.delivery_dining_outlined, color: const Color.fromARGB(255, 0, 0, 0), size: screenWidth * 0.06), // Increased icon size
                       SizedBox(width: screenWidth * 0.03),
                       Expanded(
                         child: Text(
                           'Careem - Talabat',
                           style: TextStyle(
                             fontSize: screenWidth *  0.045,
                             color: Colors.black, // Set text color to black
                           ),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: screenHeight * 0.01),
                   Row(
                     children: [
                       Icon(Icons.card_giftcard_outlined, color: const Color.fromARGB(255, 0, 0, 0), size: screenWidth * 0.06), // Increased icon size
                       SizedBox(width: screenWidth * 0.03),
                       Expanded(
                         child: Text(
                           'No Vouchers exist currently',
                           style: TextStyle(
                             fontSize: screenWidth *  0.045,
                             color: Colors.black, // Set text color to black
                           ),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: screenHeight * 0.01),
                   Row(
                     children: [
                       Icon(Icons.attach_money_outlined, color: const Color.fromARGB(255, 0, 0, 0), size: screenWidth * 0.06), // Increased icon size
                       SizedBox(width: screenWidth * 0.03),
                       Expanded(
                         child: Text(
                           '\$\$\$\$',
                           style: TextStyle(
                             fontSize: screenWidth *  0.045,
                             color: Colors.black, // Set text color to black
                           ),
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
                    
                // Menu Button
            
              ],
            ),
          ),
          Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF3C623),
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
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.045), // Increased font size
                ),
              ),
            ],
          ),
        ),
              
        ],
      ),

      // Bottom Navigation Bar
      
    );
  }
}