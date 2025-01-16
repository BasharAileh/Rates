import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/dialogs/redeem_dialog.dart';
import 'view_ratings_page.dart'; // Import the ViewRatingPage

class MenuPage extends StatefulWidget {
  const MenuPage(
      {super.key, required this.restaurantName, required this.rating});
  final String restaurantName;
  final double rating;

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  bool isFavorite = false;
  String searchQuery = "";

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,// Explicit grey[900] color for background
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white, // Grey[900] for app bar
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Menu',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Discover and rate",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.white70
                        : const Color.fromARGB(255, 93, 92, 102),
                  ),
                ),
                SizedBox(
                    width: AspectRatios.width *
                        0.02), // Add some spacing between the columns
                SizedBox(
                  height: AspectRatios.height * 0.04,
                  width: AspectRatios.width * 0.55,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for a meal',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 15.0),
                    ),
                    style: TextStyle(
                      fontSize: AspectRatios.width * 0.035,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: AspectRatios.height * 0.02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AspectRatios.width * 0.12,
                  height: AspectRatios.height * 0.055,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/testpic/babalyamen.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: AspectRatios.width * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurantName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        'Rating of ${widget.rating}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.white70 : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: toggleFavorite,
                ),
              ],
            ),
            SizedBox(height: AspectRatios.height * 0.02),
            Column(
              children: restaurant.menuItems
                  .map((menuItem) =>
                      MealCard(menuItem: menuItem, isDarkMode: isDarkMode))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.menuItem,
    required this.isDarkMode,
  });

  final Map<String, String> menuItem;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: AspectRatios.height * 0.16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            image: DecorationImage(
              image: AssetImage(menuItem["image"]!),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(190, 0, 0, 0),
                        Color.fromARGB(46, 0, 0, 0),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewRating(
                                restaurantName: restaurant.name,
                                rating: restaurant.rating,
                                mealName: menuItem["name"]!,
                                imagePath: menuItem["image"]!,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menuItem["name"]!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AspectRatios.width * 0.04,
                                color: Colors.white,
                              ),
                            ),
                            const Row(
                              children: [
                                Text(
                                  'view ratings and comments',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const VerificationDialogPage();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 0),
                            backgroundColor:
                                const Color.fromARGB(255, 243, 198, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text('Rate',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AspectRatios.height * 0.02),
      ],
    );
  }
}

class Restaurant {
  final String name;
  final double rating;
  final List<Map<String, String>> menuItems;

  Restaurant({
    required this.name,
    required this.rating,
    required this.menuItems,
  });
}

final Restaurant restaurant = Restaurant(
  name: "Bab el-yamen",
  rating: 3.5,
  menuItems: [
    {"name": "Mandi Meal", "image": "assets/images/testpic/raizmalee.jpg"},
    {"name": "Mansaf Meal", "image": "assets/images/testpic/zerbyan.jpg"},
    {"name": "Zerbyan Meal", "image": "assets/images/testpic/raizmalee.jpg"},
    {"name": "Kabseh Meal", "image": "assets/images/testpic/zerbyan.jpg"},
    {"name": "Ozii Meal", "image": "assets/images/testpic/raizmalee.jpg"},
  ],
);
