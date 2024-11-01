import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

//31.967460066377022, 35.87579288583264
double x = 31.967460066377022;
double y = 35.87579288583264;
LatLng _pgoogleolex = LatLng(x, y); //locatin
LatLng _pappleoark = LatLng(x, y);
double initialRating = 4.8; //stars

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: const Color.fromARGB(255, 15, 15, 15),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                // Define your initial rating here

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      itemSize: 25,
                      initialRating:
                          initialRating, // Use the variable for initial rating
                      minRating: 0.5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        initialRating =
                            rating; // Update the variable when the rating changes
                        print(rating);
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "$initialRating",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          //lvt,u

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(
                    50), // Adjust for an oval or rounded shape
              ),
              height: 175,
              width: 250, // Set width larger than height for an oval
              child: ClipRRect(
                // Clip the content to match the rounded container shape
                borderRadius: BorderRadius.circular(50),
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _pgoogleolex, zoom: 15),
                  markers: {
                    Marker(
                      markerId: MarkerId("_currentlocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _pgoogleolex,
                    ),
                  },
                ),
              ),
            ),
          ),

          // Row with stacked CircleAvatar and Container
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 25,
              ),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/154759399?v=4'),
              ),
              SizedBox(
                width: 35,
              ),
              Text(
                'Nar Snack',
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
              SizedBox(
                width: 45,
              ),
              Text(
                '1',
                style: TextStyle(
                  fontSize: 75,
                  color: Colors.white,
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(15),
            width: 50,
            height: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      '0785017426',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(8),
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'social media :',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.all(8),
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              FontAwesomeIcons.instagram,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.all(8),
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: "home"),
        NavigationDestination(icon: Icon(Icons.face), label: "test"),
        NavigationDestination(icon: Icon(Icons.menu), label: "menu"),
      ]),
    );
  }
}
