import 'package:flutter/material.dart'; // Import Flutter Material package for UI components
import 'package:rates/Pages/shop_page.dart';
import 'favorite_hamza.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Define the Restaurants widget as a StatefulWidget
class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key}); // Constructor for Restaurants, passing a key

  @override
  State<ShopsPage> createState() => _RestaurantsState(); // Create the state for the Restaurants widget
}

// Define the state for the Restaurants widget
class _RestaurantsState extends State<ShopsPage> {
  // List of restaurants with their names and logos
  final List<Map<String, String>> restaurants = [
    {
      "name": "4chicks", // Restaurant name
      "logo": "assets/images/_4chicks_logo.png", // Logo image path
    },
    {
      "name": "Burger Maker",
      "logo": "assets/images/BurgarMaker_Logo.jpeg",
    },
    {
      "name": "FireFly",
      "logo": "assets/images/FireFly_Logo.png",
    },
    {
      "name": "MeatMoot",
      "logo": "assets/images/MeatMoot_Logo.jpeg",
    },
    // More restaurants can be added here
  ];

  // Lists to store favorite restaurant names and logos
  final List<String> favoriteRestaurants = [];
  final List<String> favoriteLogos = [];

  // Function to toggle the favorite status of a restaurant
  void favorite_list(String name, String logo) {
    setState(() {
      // Call setState to update the UI
      if (favoriteRestaurants.contains(name)) {
        // Check if the restaurant is already a favorite
        favoriteRestaurants.remove(name); // Remove from favorites if it exists
        favoriteLogos.remove(logo); // Also remove the corresponding logo
      } else {
        favoriteRestaurants.add(name); // Add to favorites if it doesn't exist
        favoriteLogos.add(logo); // Add the corresponding logo
      }
    });
  }

  // Function to show a dialog for adding/removing favorites
  void add_to_favorite(String name, String logo) {
    // Check if the restaurant is already a favorite
    final isFavorite = favoriteRestaurants.contains(name);

    // Display a dialog for confirming the action
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isFavorite
              ? "Remove from Favorites"
              : "Add to Favorites"), // Set dialog title based on favorite status
          content: Text(isFavorite
              ? "Are you sure you want to remove $name from your favorites?"
              : "Are you sure you want to add $name to your favorites?"), // Set dialog content based on favorite status
          actions: [
            // Cancel button to close the dialog
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            // Add/Remove button to confirm the action
            TextButton(
              onPressed: () {
                favorite_list(name, logo); // Toggle favorite status
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(isFavorite ? "Remove" : "Add"), // Change button text based on action
            ),
          ],
        );
      },
    );
  }

  // Function to navigate to the FavoritesPage
  void ShowFavoritePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritePage(
          favoriteRestaurants: favoriteRestaurants, // Pass favorite restaurants to FavoritesPage
          favoriteLogos: favoriteLogos, // Pass favorite logos to FavoritesPage
          onRemoveFavorite: (name, logo) {
            // Remove from favorites when called
            setState(() {
              // Call setState to update the UI
              favoriteRestaurants.remove(name); // Remove the restaurant name from favorites
              favoriteLogos.remove(logo); // Remove the corresponding logo
            });
          },
        ),
      ),
    );
  }

  Container carouselItems(String logoPath) {
    // Builds each item in the carousel slider.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0), // Adds horizontal margin.
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(logoPath), // Loads the image from assets.
          fit: BoxFit.cover, // Fills the container with the image.
        ),
      ),
    );
  }

  // Build method to construct the UI
  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icon for the back button
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back when pressed
          },
        ),
        actions: [
          IconButton(
            onPressed: ShowFavoritePage, // Show favorites page when pressed
            icon: const Icon(Icons.favorite), // Icon for favorites
          ),
          IconButton(
            onPressed: () {}, // Placeholder for search functionality
            icon: const Icon(Icons.search), // Icon for search
          ),
        ],
        backgroundColor: const Color.fromARGB(150, 244, 143, 66), // Set app bar background color
        title: const Text(
          'Shops Page', // Title of the app bar
          textAlign: TextAlign.center, // Center the title text
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Horizontal_background.png'), // Specify your image path here
            fit: BoxFit.cover, // This will cover the entire container
          ),
        ),
        child: Column(
          children: [
            // Slider at the top
            SizedBox(
              height: totalHeight * 0.25, // Set height for the slider
              child: CarouselSlider(
                options: CarouselOptions(
            
                  height: totalHeight * 0.25, // Sets the height of the carousel
                  autoPlay: true, // Enables automatic playback of carousel
                  autoPlayInterval: const Duration(seconds: 3), // Sets interval between slides
                  autoPlayAnimationDuration: const Duration(milliseconds: 800), // Sets the animation duration for sliding
                  pauseAutoPlayOnTouch: true, // Pauses autoplay when the user interacts with the carousel
                  enlargeCenterPage: true, // Enlarge the centered item
                ),
                items: restaurants.map((restaurant) {
                  return carouselItems(restaurant['logo']!); // Build each carousel item
                }).toList(),
              ),
            ),
            // List of restaurants
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: restaurants.length, // Number of restaurant cards
                itemBuilder: (context, index) {
                  return RestaurantCard(
                    name: restaurants[index]['name']!, // Get restaurant name
                    logo: restaurants[index]['logo']!, // Get restaurant logo
                    isFavorite: favoriteRestaurants.contains(restaurants[index]['name']!), // Check if restaurant is a favorite
                    onFavoritePressed: () {
                      add_to_favorite(restaurants[index]['name']!, restaurants[index]['logo']!); // Add or remove from favorites
                    },
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

// RestaurantCard remains the same
class RestaurantCard extends StatefulWidget {
  final String name; // Name of the restaurant
  final String logo; // Logo image of the restaurant
  final bool isFavorite; // Check if the restaurant is a favorite
  final VoidCallback onFavoritePressed; // Callback for the favorite button

  // Constructor for RestaurantCard
  const RestaurantCard({
    super.key,
    required this.name, // Required restaurant name
    required this.logo, // Required restaurant logo
    required this.isFavorite, // Required flag for favorite status
    required this.onFavoritePressed, // Required callback for favorite action
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    // Get the total height and width of the device screen
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    void OpenPage(Widget page) {
      // Navigates to a specified page.
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page)); // Pushes the new page onto the navigation stack.
    }

    return GestureDetector(
      // GestureDetector to detect taps on the card
      onTap: () {
        OpenPage(const ShopPage());
      },
      child: Container(
        height: totalHeight * 0.15, // Set height of the card
        width: totalWidth * 0.9, // Set width of the card
        margin: EdgeInsets.symmetric(
          vertical: totalHeight * 0.030, // Vertical margin based on screen height
          horizontal: totalWidth * 0.04, // Horizontal margin based on screen width
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // Rounded corners for the card
          color: Colors.white, // Background color of the card
        ),
        child: Row(
          // Horizontal layout for the card
          mainAxisAlignment: MainAxisAlignment.start, // Align children to start
          children: [
            Container(
              padding: EdgeInsets.only(left: totalWidth * 0.05), // Left padding for the logo
              child: Image.asset(
                widget.logo, // Load logo image
                width: totalWidth * 0.19, // Set logo width
                height: totalHeight * 0.1, // Set logo height
                fit: BoxFit.cover, // Cover the container with the logo
              ),
            ),
            const SizedBox(width: 10), // Space between logo and text
            Expanded(
              flex: 3, // Flex factor for the text container
              child: Text(
                widget.name, // Display restaurant name
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Text style for name
              ),
            ),
            Expanded(
              flex: 1, // Flex factor for the rating and favorite icon
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space evenly within the column
                children: [
                  const Text(
                    "Rate", // Display "Rate" label
                    style: TextStyle(fontSize: 16), // Text style for label
                  ),
                  IconButton(
                    icon: Icon(
                      widget.isFavorite ? Icons.favorite : Icons.favorite_border, // Show favorite icon based on status
                      color: widget.isFavorite ? Colors.black : null, // Change icon color if it's a favorite
                    ),
                    onPressed: widget.onFavoritePressed, // Call the provided callback when pressed
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}