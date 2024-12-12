import 'package:flutter/material.dart'; // Imports the Flutter material design package.
import 'package:rates/constants/aspect_ratio.dart'; // Imports aspect ratio constants for responsive UI.
import '../../dialogs/nav_bar.dart'; // Imports a custom navigation bar widget.
import '../other/favorites_page.dart'; // Imports the FavoritesPage widget for navigation.

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() =>
      _FoodPageState(); // Creates the state for FoodPage.
}

class _FoodPageState extends State<FoodPage> {
  // List of restaurants with initial properties.
  List<Map<String, dynamic>> restaurantList = List.generate(
    10, // Generate 10 sample restaurants.
    (index) => {
      'name': 'Restaurant #$index', // Name of the restaurant.
      'rating': 1.5 + (index + 1 % 2) * 0.5, // Generates a sample rating.
      'image': 'assets/images/R.png', // Placeholder for the restaurant image.
      'isFavorite':
          false, // Indicates if the restaurant is marked as a favorite.
      'index': index, // Tracks the index for identification.
    },
  );

  // Toggles the favorite status of a restaurant.
  void toggleFavorite(int index) {
    setState(() {
      restaurantList[index]['isFavorite'] =
          !restaurantList[index]['isFavorite']; // Toggles favorite status.
    });

    // Shows a snack bar indicating the action performed.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          restaurantList[index]['isFavorite']
              ? 'Added to favorite list' // Message for adding to favorites.
              : 'Removed from favorite list', // Message for removing from favorites.
        ),
        duration: const Duration(seconds: 1), // Duration of the snack bar.
      ),
    );
  }

  // Handles navigation for BottomNavigationBar item selection.
  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigates to FavoritesPage when the second item is tapped.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritesPage(
            favorites: restaurantList
                .where((restaurant) => restaurant['isFavorite'])
                .toList(), // Filters the favorite restaurants.
            onRemoveFavorite: (index) {
              setState(() {
                restaurantList[index]['isFavorite'] =
                    false; // Updates favorite status.
              });
            },
          ),
        ),
      );
    }
  }

  // Widget for displaying a single restaurant card.
  Widget restaurantCard({
    required String name, // Restaurant name.
    required String image, // Restaurant image.
    required double rating, // Restaurant rating.
    required bool isFavorite, // Whether the restaurant is a favorite.
    required VoidCallback
        onFavoriteToggle, // Callback for toggling favorite status.
    required VoidCallback
        onDetailsPressed, // Callback for viewing restaurant details.
  }) {
    Color ratingColor; // Stores the color for rating.
    String ratingText = "Rating of "; // Label for the rating text.

    // Determine the color of the rating text based on its value.
    if (rating >= 4) {
      ratingColor = Colors.green; // Green for high ratings.
    } else if (rating >= 3) {
      ratingColor = Colors.orange; // Orange for medium ratings.
    } else {
      ratingColor = Colors.red; // Red for low ratings.
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the card.
        borderRadius: BorderRadius.circular(10), // Rounded corners.
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1), // Shadow color with opacity.
            blurRadius: 0, // Blur radius for the shadow.
            offset: const Offset(0, 2), // Shadow offset.
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            image, // Displays the restaurant image.
            height: 69, // Fixed height for the image.
            width: 67, // Fixed width for the image.
          ),
          const SizedBox(width: 10), // Space between image and text.

          // Restaurant information section.
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns text to the left.
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centers text vertically.
              children: [
                Row(
                  children: [
                    Text(
                      name, // Displays the restaurant name.
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5), // Space between text elements.
                    const Text(
                      "#1st Place", // Example ranking text.
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 2), // Space below the name.
                Row(
                  children: [
                    Text(
                      ratingText, // Rating label text.
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    Text(
                      "$rating stars", // Displays the rating value.
                      style: TextStyle(color: ratingColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 3), // Space below the rating.
                InkWell(
                  onTap: onDetailsPressed, // Trigger details view callback.
                  child: const Text(
                    "View Details", // Details button text.
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          // Favorite icon button for toggling favorite status.
          IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons
                      .favorite_border, // Icon changes based on favorite status.
              color: isFavorite
                  ? Colors.red
                  : Colors.grey, // Icon color changes based on favorite status.
            ),
            onPressed: onFavoriteToggle, // Calls the favorite toggle callback.
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width.

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
                        restaurantList[index]['isFavorite'] = false;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: AspectRatios.width * 0.045),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Discover and Rate",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                Center(
                  child: SizedBox(
                    height: AspectRatios.height * 0.031591796875,
                    width: screenWidth *
                        0.5807692307692308, // Adjust width dynamically.
                    child: SearchBar(
                      hintText: "Search for restaurants",
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      leading: const Icon(Icons.search,
                          color: Colors.black, size: 20),
                      onChanged: (query) {},
                      onSubmitted: (query) {},
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  onPressed: () {
                    // Add filter logic here
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];
                  return SizedBox(
                    height: AspectRatios.height * 0.12,
                    width: AspectRatios.width * 0.8,
                    child: restaurantCard(
                      name: restaurant['name'],
                      image: restaurant['image'],
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
