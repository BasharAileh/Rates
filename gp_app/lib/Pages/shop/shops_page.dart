import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/Pages/shop/rest_info_page.dart';
import 'package:rates/constants/aspect_ratio.dart';
import '../../dialogs/nav_bar.dart';
import '../other/favorites_page.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> restaurantList = List.generate(
    10,
    (index) => {
      'name': 'Bab Elyamen',
      'rating': 1.5 + (index + 1 % 2) * 0.5,
      'image': 'assets/images/Bashar_Akileh.jpg',
      'isFavorite': false,
      'index': index,
    },
  );

  void _filterRestaurants(String query) {
    setState(() {
      restaurantList = List.generate(
        10,
        (index) => {
          'name': 'Restaurant #$index',
          'rating': 1.5 + (index + 1 % 2) * 0.5,
          'image': 'assets/images/Bashar_Akileh.jpg',
          'isFavorite': false,
          'index': index,
        },
      ).where((restaurant) {
        final name = restaurant['name'] as String?;
        return name != null && name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sortRestaurants(String criteria) {
    setState(() {
      if (criteria == 'Rating') {
        restaurantList.sort((a, b) => b['rating'].compareTo(a['rating']));
      } else if (criteria == 'Alphabetical') {
        restaurantList.sort((a, b) => a['name'].compareTo(b['name']));
      }
    });
  }

  void toggleFavorite(int index) {
    final previousState = restaurantList[index]['isFavorite'];

    setState(() {
      restaurantList[index]['isFavorite'] = !previousState;
    });

    showSnackBar(restaurantList[index]['isFavorite'], index);
  }

  void showSnackBar(bool isFavorite, int index) {
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
          ClipOval(
            child: Image.asset(
              image,
              height: 69,
              width: 67,
              fit: BoxFit.cover,
            ),
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
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
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
      body: Container(
        color: Colors.white, // Set body background color to white
        child: Padding(
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
                  SizedBox(width: 5),
                  Expanded(
                    child: SizedBox(
                      height: AspectRatios.height * 0.03197265625,
                      width: AspectRatios.width * 0.4807692307692308,
                      child: TextField(
                        //onChanged: ,
                        decoration: InputDecoration(
                          hintText: 'Search for restaurants',
                          prefixIcon: const Icon(Icons.search),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_list, color: Colors.black),
                    onSelected: _sortRestaurants,
                    itemBuilder: (BuildContext context) {
                      return ['Rating', 'Alphabetical']
                          .map((String choice) => PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              ))
                          .toList();
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
                              builder: (context) => RestaurantInformationPage(rating: restaurant['rating'],restaurantName:restaurant['name']),
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
      ),
    );
  }
}
