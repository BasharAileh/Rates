import 'package:flutter/material.dart';
import 'package:rates/dialogs/nav_bar.dart';
import 'package:rates/constants/aspect_ratio.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        endDrawer: const NavBar(),
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 26, 26, 26),
          elevation: 0,
          title: const Text(
            "Favourites",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.filter_list),
                  color: Colors.amber,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(AspectRatios.width * 0.04),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  hintText: "Search",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AspectRatios.width * 0.075),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: AspectRatios.height * 0.02),
              Expanded(
                child: ListView(
                  children: [
                    _buildListItem(
                      context,
                      "Toyo Eatery",
                      "3 Greenwich Ave, New York",
                      "(4.9)",
                      "(132)",
                      'assets/images/golden_crown.png',
                    ),
                    _buildListItem(
                      context,
                      "Toyo Eatery",
                      "3 Greenwich Ave, New York",
                      "(4.9)",
                      "(132)",
                      'assets/images/golden_crown.png',
                    ),
                    _buildListItem(
                      context,
                      "Toyo Eatery",
                      "3 Greenwich Ave, New York",
                      "(4.9)",
                      "(132)",
                      'assets/images/golden_crown.png',
                    ),
                    _buildListItem(
                      context,
                      "Toyo Eatery",
                      "3 Greenwich Ave, New York",
                      "(4.9)",
                      "(132)",
                      'assets/images/golden_crown.png',
                    ),
                    _buildListItem(
                      context,
                      "Toyo Eatery",
                      "3 Greenwich Ave, New York",
                      "(4.9)",
                      "(132)",
                      'assets/images/golden_crown.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    String title,
    String address,
    String rating,
    String rates,
    String restLogo,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(
          AspectRatios.width * 0.001,
          AspectRatios.height * 0.015,
          AspectRatios.width * 0.001,
          AspectRatios.height * 0.015,
        ),
        padding: EdgeInsets.all(AspectRatios.width * 0.03),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(AspectRatios.width * 0.05),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AspectRatios.width * 0.04),
              child: Image.asset(
                restLogo,
                fit: BoxFit.cover,
                height: AspectRatios.height * 0.12,
                width: AspectRatios.width * 0.2,
              ),
            ),
            SizedBox(width: AspectRatios.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AspectRatios.width * 0.045,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.favorite,
                            color: Colors.red, size: 30),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: AspectRatios.height * 0.005),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.amberAccent, size: 14),
                      Text(
                        address,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: AspectRatios.width * 0.035,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AspectRatios.height * 0.005),
                  Row(
                    children: [
                      Text(
                        rates,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      SizedBox(width: AspectRatios.width * 0.01),
                      const Icon(Icons.favorite, color: Colors.red, size: 14),
                      const Spacer(),
                      Text(
                        rating,
                        style: TextStyle(
                          color: Colors.white,
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
