import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import '../../dialogs/nav_bar.dart';
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
      'rating': 1.5 + (index + 1 % 2) * 0.5,
      'image':
          'https://via.placeholder.com/70', // Replace with actual image URL
      'isFavorite': false,
      'index': index, // Add an index to help identify the restaurant
    },
  );

  void toggleFavorite(int index) {
    setState(() {
      restaurantList[index]['isFavorite'] =
          !restaurantList[index]['isFavorite'];
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

  // Method to handle BottomNavigationBar item selection
  void _onItemTapped(int index) {
    setState(() {});

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritesPage(
            favorites: restaurantList
                .where((restaurant) => restaurant['isFavorite'])
                .toList(),
            onRemoveFavorite: (index) {
              setState(() {
                restaurantList[index]['isFavorite'] =
                    false; // Set the isFavorite flag back to false
              });
            },
          ),
        ),
      );
    }
  }

  // RestaurantCard widget
  Widget restaurantCard({
    required String name,
    required String logo,
    required double rating,
    required bool isFavorite,
    required VoidCallback onFavoriteToggle,
    required VoidCallback onDetailsPressed,
  }) {
    Color ratingColor;
    String ratingText = "Rating of ";

    // Determine rating color
    if (rating >= 4) {
      ratingColor = Colors.green;
    } else if (rating >= 3) {
      ratingColor = Colors.orange;
    } else {
      ratingColor = Colors.red;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AspectRatios.height * 0.015),
      child: Container(
        padding: EdgeInsets.all(AspectRatios.width * 0.025),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo container
            Container(
              height: AspectRatios.height * 0.1,
              width: AspectRatios.width * 0.15,
              color: Colors.black,
              child: Center(
                child: Text(
                  logo,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
                width:
                    AspectRatios.width * 0.05), // Space between logo and text

            // Restaurant information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: AspectRatios.width * 0.01),
                      const Text(
                        "#1st Place",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: AspectRatios.height * 0.005),
                  Row(
                    children: [
                      Text(
                        ratingText,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      Text(
                        "$rating stars", // The rating value itself
                        style: TextStyle(color: ratingColor, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: AspectRatios.height * 0.01),
                  InkWell(
                    onTap: onDetailsPressed,
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            // Favorite Icon button
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(
                    favorites: restaurantList
                        .where((restaurant) => restaurant['isFavorite'])
                        .toList(),
                    onRemoveFavorite: (index) {
                      setState(() {
                        restaurantList[index]['isFavorite'] =
                            false; // Set the isFavorite flag back to false
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: AspectRatios.height * 0.02158203125,
                  width: AspectRatios.width * 0.2538461538461538,
                  child: const Text(
                    "Discover and rate",
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                SizedBox(width: AspectRatios.width * 0.01),
                Container(
                  height: AspectRatios.height *
                      0.035, // Adjusted height to make it more consistent
                  width: AspectRatios.width *
                      0.5807692307692308, // Adjusted width to make the search bar wider
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for restaurants",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AspectRatios.width *
                            0.05, // Horizontal padding for text
                        vertical: AspectRatios.height *
                            0.01, // Vertical padding for better alignment
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      suffixIcon:  
                         IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 20, // Smaller icon size
                          ),
                          onPressed: () {
                            // Handle search action here
                          },
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
                  return restaurantCard(
                    name: restaurant['name'],
                    logo: "Logo", // You can replace this with actual image
                    rating: restaurant['rating'],
                    isFavorite: restaurant['isFavorite'],
                    onFavoriteToggle: () => toggleFavorite(index),
                    onDetailsPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailsPage(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
