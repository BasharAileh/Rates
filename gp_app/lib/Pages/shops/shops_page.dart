import 'package:flutter/material.dart'; // Imports the Flutter material design package.
import 'package:rates/constants/aspect_ratio.dart'; // Imports aspect ratio constants for responsive UI.
import '../../dialogs/nav_bar.dart'; // Imports a custom navigation bar widget.
import '../other/favorites_page.dart'; // Imports the FavoritesPage widget for navigation.

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState(); // Creates the state for FoodPage.
}

class _FoodPageState extends State<FoodPage> with TickerProviderStateMixin {
  // List of restaurants with initial properties.
  List<Map<String, dynamic>> restaurantList = List.generate(
    10, // Generate 10 sample restaurants.
    (index) => {
      'name': 'Restaurant #$index', // Name of the restaurant.
      'rating': 1.5 + (index + 1 % 2) * 0.5, // Generates a sample rating.
      'image': 'assets/images/Bashar_Akileh.jpg', // Placeholder for the restaurant image.
      'isFavorite': false, // Indicates if the restaurant is marked as a favorite.
      'index': index, // Tracks the index for identification.
    },
  );

  // Filter restaurants based on the search query.
  void _filterRestaurants(String query) {
    setState(() {
      restaurantList = List.generate(
        10,
        (index) => {
          'name': 'Restaurant #$index',
          'rating': 1.5 + (index + 1 % 2) * 0.5,
          'image': 'assets/images/R.png',
          'isFavorite': false,
          'index': index,
        },
      ).where((restaurant) {
        final name = restaurant['name'] as String?;
        return name != null && name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // Toggles the favorite status of a restaurant with undo functionality.
  void toggleFavorite(int index) {
    final previousState = restaurantList[index]['isFavorite']; // Store previous state.

    setState(() {
      restaurantList[index]['isFavorite'] = !previousState; // Toggle favorite status.
    });

    // Shows a custom SnackBar from the top of the screen.
    showTopSnackBar(context, restaurantList[index]['isFavorite'], index);
  }

  // Function to show the custom SnackBar at the top of the screen.
  void showTopSnackBar(BuildContext context, bool isFavorite, int index) {
    final snackBarContent = isFavorite ? 'Added to favorite list' : 'Removed from favorite list';

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100, // Adjust the vertical position
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: AnimatedSlide(
            offset: Offset(0, -1), // Start off-screen (above)
            duration: const Duration(milliseconds: 200),
            curve: Curves.decelerate, // Smooth curve for slide effect
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    snackBarContent,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      // Undo action
                      setState(() {
                        restaurantList[index]['isFavorite'] = !isFavorite;
                      });
                    },
                    child: const Text(
                      'Undo',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay after a short delay (same duration as snack bar)
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  // Widget for displaying a single restaurant card.
  Widget restaurantCard({
    required String name,
    required String image,
    required double rating,
    required bool isFavorite,
    required VoidCallback onFavoriteToggle,
    required VoidCallback onDetailsPressed,
  }) {
    Color ratingColor;
    String ratingText = "Rating of ";

    if (rating >= 4) {
      ratingColor = Colors.green;
    } else if (rating >= 3) {
      ratingColor = Colors.orange;
    } else {
      ratingColor = Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 69,
            width: 67,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "#1st Place",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      ratingText,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    Text(
                      "$rating stars",
                      style: TextStyle(color: ratingColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                InkWell(
                  onTap: onDetailsPressed,
                  child: const Text(
                    "View Details",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    onChanged: _filterRestaurants, // Filters restaurants as the user types
                    decoration: InputDecoration(
                      hintText: 'Search for restaurants',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
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
