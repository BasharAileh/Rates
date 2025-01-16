import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/Pages/shop/rest_info_page.dart';

class FavoritesPage extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final Function(int) onRemoveFavorite;

  const FavoritesPage({
    required this.favorites,
    required this.onRemoveFavorite,
    super.key,
  });

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<Map<String, dynamic>> favorites;

  @override
  void initState() {
    super.initState();
    favorites = widget.favorites;
  }

  void removeFromFavorites(int index) {
    final removedRestaurant = favorites[index];
    setState(() {
      favorites.removeAt(index);
    });

    widget.onRemoveFavorite(removedRestaurant['index']);

    // Replace the snackbar with Get.snackbar
    showSnackBar(false, removedRestaurant['name']);
  }

  void showSnackBar(bool isFavorite, String name) {
    String snackBarTitle =
        isFavorite ? "Added to Favorite List" : "Removed from Favorite List";
    String snackBarMessage = isFavorite
        ? "The item has been successfully added to your favorite list."
        : "The item has been removed from your favorite list.";

    Get.snackbar(
      snackBarTitle, // Title
      snackBarMessage, // Message
      titleText: Text(
        snackBarTitle,
        style: const TextStyle(
          fontSize: 16, // Title font size
          fontWeight: FontWeight.bold, // Bold title
        ),
      ),
      messageText: Text(
        snackBarMessage,
        style: const TextStyle(
          fontSize: 12, // Message font size
          fontWeight: FontWeight.normal, // Regular weight for message
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 191, 191, 191),
      colorText: const Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.only(top: 10, left: 7, right: 7),
      padding: const EdgeInsets.all(5),
      boxShadows: [
        const BoxShadow(
          color: Color.fromARGB(255, 56, 56, 56),
          offset: Offset(0, 2),
          blurRadius: 5,
          spreadRadius: 0.5,
        ),
      ],
    );
  }

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

    if (rating >= 4) {
      ratingColor = Colors.green;
    } else if (rating >= 3) {
      ratingColor = Colors.orange;
    } else {
      ratingColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              color: Colors.black,
              child: Center(
                child: Text(
                  logo,
                  style: const TextStyle(color: Colors.white),
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
                        name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "#1st Place",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        ratingText,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      Text(
                        "$rating stars",
                        style: TextStyle(color: ratingColor, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
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
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final restaurant = favorites[index];
            return restaurantCard(
              name: restaurant['name'],
              logo: "Logo",
              rating: restaurant['rating'],
              isFavorite: true,
              onFavoriteToggle: () => removeFromFavorites(index),
              onDetailsPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RestaurantInformationPage(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
