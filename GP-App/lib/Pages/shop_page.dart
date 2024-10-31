import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Shop extends StatefulWidget {
  @override
  State<Shop> createState() => _ShopState();
}
double initialRating = 4.0;
class _ShopState extends State<Shop> {
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

                RatingBar.builder(
                  itemSize: 25,
                  initialRating: initialRating, // Use the variable for initial rating
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    initialRating = rating; // Update the variable when the rating changes
                    print(rating);
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.red),
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.all(15.0),
              height: 175,
              child: const Center(
                child: Text(
                  "API",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
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
                    Text(
                      'social media :',
                      style: TextStyle(color: Colors.white),
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