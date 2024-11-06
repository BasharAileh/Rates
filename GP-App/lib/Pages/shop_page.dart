import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rates/constants/app_colors.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

// Coordinates and rating
double x = 31.967460066377022;
double y = 35.87579288583264;
LatLng _pappleoark = LatLng(x, y);
double initialRating = 4.8;
const LatLng _pgoogleolex = LatLng(32.02865124594849, 35.86541900000043);
const String r_name = ' Fire Fly ';
const String pnum = '+962795041122';

// Function to open the map
Future<void> _openMap() async {
  final Uri url = Uri.parse('https://maps.app.goo.gl/jWmCJh4masy9TcRp6');
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not open Google Maps.';
  }
}

// Function to launch the URL
Future<void> urllauncher(String name) async {
  String url = "";
  if (name == "facebook") {
    url = "https://web.facebook.com/FireFlyBurger/?_rdc=1&_rdr#";
  } else if (name == "instagram") {
    url = "https://www.instagram.com/fireflyburgerjo/?hl=ar";
  } else if (name == "whatsapp") {
    url = "https://web.whatsapp.com/";
  }
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw "could not launch $url";
  }
}

// Function to launch the phone dialer
void _launchPhoneDialer(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch $launchUri';
  }
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop', style: TextStyle(fontFamily: 'Nexa')),
        centerTitle: true,
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Horizontal_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: AppColors.cardBackgroundOpacity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: initialRating,
                            minRating: 0.5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                initialRating = rating;
                              });
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                              "$initialRating",
                              style: const TextStyle(color: Colors.black, fontFamily: 'Nexa'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _openMap,
                child: Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    height: 175,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: _pgoogleolex,
                          zoom: 19,
                        ),
                        markers: {
                          const Marker(
                            markerId: MarkerId("_currentlocation"),
                            icon: BitmapDescriptor.defaultMarker,
                            position: _pgoogleolex,
                          ),
                        },
                        scrollGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/FireFly_Logo.png'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        r_name,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontFamily: 'Nexa',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Rating: $initialRating',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: 'Nexa',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "1",
                    style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Nexa'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Card(
                color: AppColors.cardBackgroundOpacity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Open: 10 am - 2 am',
                        style: TextStyle(color: Colors.black, fontFamily: 'Nexa'),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Order from: Talabat, Careem, Own Delivery',
                        style: TextStyle(color: Colors.black, fontFamily: 'Nexa'),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            'Phone: ',
                            style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Nexa'),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchPhoneDialer(pnum);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.all(4),
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                FontAwesomeIcons.phone,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Social Media:',
                        style: TextStyle(color: Colors.black, fontFamily: 'E:\\GP\\rates2\\Rates\\GP-App\\assets\\fonts\\nexa\\Nexa-ExtraLight.ttf'),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              urllauncher("instagram");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.all(4),
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              urllauncher("facebook");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.all(4),
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.appBarColor,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.face), label: "Profile"),
          NavigationDestination(icon: Icon(Icons.menu), label: "Menu"),
        ],
      ),
    );
  }
}