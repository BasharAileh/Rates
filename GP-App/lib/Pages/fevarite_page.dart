import 'package:flutter/material.dart';
import 'package:newproject2/constents.dart';
import 'package:newproject2/test.dart';

class FavoritesPage extends StatefulWidget {
  final List<String> favoriteRestaurants; // To hold the list of favorite restaurant names
  final List<String> favoriteLogos; // To hold the list of favorite restaurant logos
  final Function(String, String) onRemoveFavorite; // Callback to handle removal from favorites

  const FavoritesPage({
    Key? key,
    required this.favoriteRestaurants,
    required this.favoriteLogos,
    required this.onRemoveFavorite, // Receive the removal function
  }) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  void _showRemoveFavoriteDialog(BuildContext context, String name, String logo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Remove from Favorites"),
          content: Text("Are you sure you want to remove $name from your favorites?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                favoriteRestaurants.remove(name);
                favoriteLogos.remove(logo); // Call the function to remove from favorites
                Navigator.of(context).pop(); // Close the dialog  
                });
                
              },
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Restaurants"),
        backgroundColor: const Color.fromARGB(
          150, 244, 143, 66),
      ),
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'images/Horizontal_background.png'), // Specify your image path here
          fit: BoxFit.cover, // This will cover the entire container
        ),),
        child: widget.favoriteRestaurants.isEmpty
            ? Center(child: Text("No favorite restaurants added."))
            : ListView.builder(
                itemCount: widget.favoriteRestaurants.length,
                itemBuilder: (context, index) {
                  return RestaurantCard(
                    name: widget.favoriteRestaurants[index],
                    logo: widget.favoriteLogos[index],
                    isFavorite: true, // All items here are favorites
                    onFavoritePressed: () {
                      _showRemoveFavoriteDialog(context, widget.favoriteRestaurants[index], widget.favoriteLogos[index]);
                    },
                  );
                },
              ),
      ),
    );
  }
}
