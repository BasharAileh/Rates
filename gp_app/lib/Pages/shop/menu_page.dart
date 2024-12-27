import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rates/Pages/shop/rest_info_page.dart';
import 'package:rates/Pages/shop/view_ratings_page.dart';

// Import the ViewRatingPage

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final String restaurantName = "Bab el-yamen";
  final String rating = "3.5 stars";
  final List<Map<String, String>> menuItems = [
    {"name": "raiz male with chicken", "image": "assets/images/testpic/raizmalee.jpg"},
    {"name": "raiz male with beef", "image": "assets/images/testpic/raizmalee.jpg"},
    {"name": "raiz male with lamb", "image": "assets/images/testpic/raizmalee.jpg"},
    {"name": "raiz male with fish", "image": "assets/images/testpic/babalyamen.jpg"},
    {"name": "raiz male with vegetables", "image": "assets/images/testpic/raizmalee.jpg"}
  ];
  String searchQuery = "";
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<Map<String, String>> filteredMenuItems = menuItems
        .where((item) => item["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RestaurantInformationPage()),
            );
          },
        ),
        title: const Text(
          'Menu',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isVisible ? kToolbarHeight : 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    "Discover and rate",
                    style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold, color: const Color(0xFF5D5C66)),
                  ),
                  SizedBox(width: screenWidth * 0.02), // Add some spacing between the columns
                  SizedBox(
                    height: screenHeight * 0.04,
                    width: screenWidth * 0.55,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search for a meal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0), // Adjusted padding
                      ),
                      style: TextStyle(fontSize: screenWidth * 0.035), // Adjusted font size
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isVisible ? kToolbarHeight : 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 0.12,
                    height: screenWidth * 0.12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/testpic/babalyamen.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantName,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rating of $rating',
                          style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.favorite_border, color: Colors.black, size: screenWidth * 0.06),
                ],
              ),
            ),
          ),
          
          Expanded(
            
            child: ListView.builder(
              controller: _scrollController,
              itemCount: filteredMenuItems.length,
              itemBuilder: (context, index) {
                return Column(
                  
                  children: [
                     Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: screenWidth*0.059,),
                              Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          filteredMenuItems[index]["name"]!, // Use the name from the filtered list
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.04,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                            ],
                          ),
                    Container(
                      height: screenHeight / 5.5, // Adjust the height to show 4 items at once
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(filteredMenuItems[index]["image"]!), // Use the image from the filtered list
                          fit: BoxFit.fill,
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
                                 Color.fromRGBO(0, 0, 0, 0.75),
                                 Color.fromRGBO(0, 0, 0, 0.1875),
                             
                            ],
                          ), // Transparent black overlay
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.003),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const ViewRating()),
                                          );
                                        },
                                        // Transparent black background
                                        
                                        child: Row(
                                          children: [
                                            Text(
                                              'view ratings and comments',
                                              style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: screenWidth * 0.04,
                                            ),
                                          ],
                                        ),
                                        
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF3C623),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                           // Increase elevation for a more pronounced shadow
                                        ),
                                        child: Text('Rate', style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.white)),
                                      ),
                                      
                                    ],
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      
    );
  }
}