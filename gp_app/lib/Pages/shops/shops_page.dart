import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<bool> favoriteList = List.generate(10, (_) => false);

  void toggleFavorite(int index) {
    setState(() {
      favoriteList[index] = !favoriteList[index];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          favoriteList[index]
              ? 'Added to favorite list'
              : 'Removed from favorite list',
        ),
        duration: const Duration(seconds: 1),
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
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Discover and rate",
                  style: TextStyle(fontSize: 11),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 30, // Adjusted height for better alignment
                  width: 230, // Adjusted width for the search box
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for restaurants",
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      filled: true,
                      fillColor: Colors.white, // Light background color
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Circular border
                        borderSide: const BorderSide(color: Colors.black), // Remove border outline
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: () {},
                      ), // Search icon inside the box
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      height: 70,
                      child: Row(
                        children: [
                          Container(
                            height: 76,
                            width: 76,
                            color: Colors.black,
                            child: const Center(
                              child: Text(
                                "Logo",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Restaurant Name",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "#1st Place",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Rating of 3.5 stars",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12 // Change dynamically
                                      ),
                                ),
                                const SizedBox(height: 7),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurantDetailsPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "View Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              favoriteList[index]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoriteList[index]
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () => toggleFavorite(index),
                          ),
                        ],
                      ),
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

class RestaurantDetailsPage extends StatelessWidget {
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
          'Restaurant Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Details of the restaurant will go here."),
      ),
    );
  }
}
