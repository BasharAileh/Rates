import 'package:flutter/material.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/dialogs/nav_bar.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  int currentIndex = 0; // Track the selected index for bottom navigation bar

  // List of titles for the app bar based on selected tab
  final List<String> titles = ["Favorites"];

  // List of routes for navigation(others routs not ready yet)
  final List<String> routes = [homeRoute];
  // List of the favorite restaurants
  List<Map<String, String>> favoriteRestaurants = [
    // data of favorite restaurants
    {
      'title': 'FireFly',
      'address': '3 Greenwich Ave, New York',
      'rating': '(4.9)',
      'rates': '(132)',
      'restLogo': 'assets/images/FireFly_Logo.png',
    },
    {
      'title': 'Shwarma3Saj',
      'address': '4 Main St, New York',
      'rating': '(4.7)',
      'rates': '(98)',
      'restLogo': 'assets/images/SawermaSaj_logo.png',
    },
    {
      'title': '4chicks',
      'address': '3 Greenwich Ave, New York',
      'rating': '(4.9)',
      'rates': '(132)',
      'restLogo': 'assets/images/_4chicks_logo.png',
    },
    {
      'title': 'MeatMoot',
      'address': '4 Main St, New York',
      'rating': '(4.7)',
      'rates': '(98)',
      'restLogo': 'assets/images/MeatMoot_Logo.jpeg',
    },
    {
      'title': 'BurgarMaker',
      'address': '3 Greenwich Ave, New York',
      'rating': '(4.9)',
      'rates': '(132)',
      'restLogo': 'assets/images/BurgarMaker_Logo.jpeg',
    },
    {
      'title': 'CloudShot',
      'address': '4 Main St, New York',
      'rating': '(4.7)',
      'rates': '(98)',
      'restLogo': 'assets/images/CloudShot_logo.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Bottom navigation bar
        bottomNavigationBar: NavigationBar(
          backgroundColor: AppColors.appBarColor,
          height: AspectRatios.height * 0.07,
          selectedIndex: currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index; // Update the selected index
            });
            Navigator.of(context)
                .pushNamed(routes[index]); // Navigate to the respective route
          }, // Height based on AspectRatios
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "home"),
            NavigationDestination(
                icon: Icon(Icons.category), label: "Category"),
            NavigationDestination(icon: Icon(Icons.person_2), label: "Profile"),
          ],
        ),
        // End drawer for navigation menu
        endDrawer: const NavBar(),
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          title: Text(
            titles[currentIndex], // Dynamically change the title
            style: const TextStyle(
                color: AppColors.textColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop(); // Go back to the previous screen
            },
          ),
          actions: [
            // Filter button to open the navigation drawer
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.filter_list),
                  color: const Color.fromARGB(255, 0, 0, 0),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer(); // Open the end drawer
                  },
                );
              },
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Horizontal_background.png'),
              fit: BoxFit.cover, // Background image for the page
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
                AspectRatios.width * 0.04), // Padding around the content
            child: Column(
              children: [
                // Search TextField
                TextField(
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.textColor),
                    hintText: "Search",
                    hintStyle: const TextStyle(color: AppColors.textColor),
                    filled: true,
                    fillColor:
                        const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AspectRatios.width * 0.075),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                    height: AspectRatios.height *
                        0.02), // Spacer between the search bar and list
                Expanded(
                  // build the List of favorite restaurants
                  child: ListView.builder(
                    itemCount: favoriteRestaurants
                        .length, // Number of items in the list
                    itemBuilder: (context, index) {
                      var restaurant = favoriteRestaurants[index];
                      return buildListItem(
                        context,
                        restaurant['title']!,
                        restaurant['address']!,
                        restaurant['rating']!,
                        restaurant['rates']!,
                        restaurant['restLogo']!,
                        index, // Passing the index to identify the restaurant
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to build each item of the list
  Widget buildListItem(
    BuildContext context,
    String title,
    String address,
    String rating,
    String rates,
    String restLogo,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(shopRoute);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(
          AspectRatios.width * 0.001,
          AspectRatios.height * 0.015,
          AspectRatios.width * 0.001,
          AspectRatios.height * 0.015,
        ),
        padding: EdgeInsets.all(AspectRatios.width * 0.03),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundOpacity,
          borderRadius: BorderRadius.circular(AspectRatios.width * 0.05),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: AspectRatios.width * 0.125,
              backgroundImage: AssetImage(
                restLogo,
              ),
            ),
            SizedBox(
                width:
                    AspectRatios.width * 0.04), // Spacer between logo and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant name and heart icon for removing from favorites
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: AspectRatios.width * 0.045,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.favorite,
                            color: Color.fromARGB(255, 244, 67, 54), size: 30),
                        onPressed: () {
                          // Show confirmation dialog before deleting the restaurant
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Favorite'),
                                content: const Text(
                                    'Are you sure you want to remove this restaurant from your favorites?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        // Remove the restaurant from the list
                                        favoriteRestaurants.removeAt(index);
                                      });
                                      Navigator.of(context)
                                          .pop(); // Close the dialog after deletion
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                      height: AspectRatios.height *
                          0.005), // Spacer between name and address
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Color.fromARGB(255, 0, 0, 0), size: 14),
                      Text(
                        address,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: AspectRatios.width * 0.035,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: AspectRatios.height *
                          0.005), // Spacer between address and rating
                  Row(
                    children: [
                      Text(
                        rates,
                        style: const TextStyle(color: AppColors.textColor),
                      ),
                      SizedBox(width: AspectRatios.width * 0.01),
                      const Icon(Icons.favorite,
                          color: Color.fromARGB(255, 244, 67, 54), size: 14),
                      const Spacer(),
                      Text(
                        rating,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: AspectRatios.width * 0.04,
                        ),
                      ),
                    ],
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
