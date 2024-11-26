import 'package:flutter/material.dart';

import '../other/favorites_page.dart';

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<Map<String, dynamic>> restaurantList = List.generate(
    10,
    (index) => {
      'name': 'Restaurant #$index',
      'rating': 3.5 + (index % 2) * 0.5,
      'image': 'https://via.placeholder.com/70', // Replace with actual image URL
      'isFavorite': false,
    },
  );

  void toggleFavorite(int index) {
    setState(() {
      restaurantList[index]['isFavorite'] = !restaurantList[index]['isFavorite'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          restaurantList[index]['isFavorite']
              ? 'Added to favorite list'
              : 'Removed from favorite list',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: const Text(
          'Food',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              // Navigate to FavoritesPage with the favorite restaurants
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(
                    favorites: restaurantList
                        .where((restaurant) => restaurant['isFavorite'])
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Discover and rate",
                  style: TextStyle(fontSize: 11),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 30, // Adjusted height for better alignment
                  width: 230, // Adjusted width for the search box
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for restaurants",
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      filled: true,
                      fillColor: Colors.white, // Light background color
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Circular border
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed: () {},
                  padding: EdgeInsets.zero, // Removed default padding
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      height: 70,
                      child: Row(
                        children: [
                          Container(
                            height: 76,
                            width: 76,
                            color: Colors.black,
                            child: const Center(
                              child: Text(
                                "Logo",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      restaurant['name'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "#1st Place",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rating of ${restaurant['rating']} stars",
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurantDetailsPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "View Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              restaurant['isFavorite']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: restaurant['isFavorite']
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () => toggleFavorite(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Restaurant Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Details of the restaurant will go here."),
      ),
    );
  }
}
