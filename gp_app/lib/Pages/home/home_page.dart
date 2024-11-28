import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/dialogs/nav_bar.dart'; // Import the navigation controller
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import smooth page indicator

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String currentCategory = "Food";
  PageController pageController = PageController(); // Page controller for the swiping
  int currentPage = 0; // Current page for the indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/logos/black_logo.svg',
          height: AspectRatios.height * 0.06,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories Section
              buildCategoriesSection(AspectRatios.width, AspectRatios.height),
              // Top Rated Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Rated',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          currentCategory,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed:
                              () {}, // Keep it empty since PopupMenuButton handles the tap
                          icon: PopupMenuButton<String>(
                            icon: const Icon(Icons.filter_list,
                                color: Colors.black87),
                            color: Colors
                                .white, // Background color of the popup menu
                            onSelected: (String value) {
                              setState(() {
                                currentCategory = value;
                              });
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Food',
                                child: Text(
                                  'Food',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87, // Text color
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(), // Divider line between menu items
                              const PopupMenuItem<String>(
                                value: 'Services',
                                child: Text(
                                  'Services',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(),
                              const PopupMenuItem<String>(
                                value: 'Cloths',
                                child: Text(
                                  'Cloths',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(),
                              const PopupMenuItem<String>(
                                value: 'Education',
                                child: Text(
                                  'Education',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(),
                              const PopupMenuItem<String>(
                                value: 'Cars',
                                child: Text(
                                  'Cars',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                              side: BorderSide(
                                color: Colors.grey[300]!, // Light grey border
                                width: 1,
                              ),
                            ),
                            elevation: 4, // Slight shadow for depth
                          )),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Monthly Finest',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentCategory, // Display the current category
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Optional: add color for distinction
                    ),
                  ),
                ],
              ),
              SizedBox(height: AspectRatios.height * 0.01),
              buildPodiumSection(
                items: [
                  {'content': "assets/images/FireFly_Logo.png"},
                  {'content': "assets/images/_4chicks_logo.png"},
                  {'content': "assets/images/CloudShot_logo.png"},
                ],
              ),
              SizedBox(height: AspectRatios.height * 0.01),
              Center(
                child: SmoothPageIndicator(
                  controller: pageController, 
                  count: 5, // Number of items in the PageView
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color.fromARGB(255, 255, 196, 45),
                    dotHeight: 4,
                    dotWidth: 8,
                  ), // Dots style
                ),
              ),
              // Yearly Finest Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Yearly Finest',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentCategory, // Display the current category
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Optional: add color for distinction
                    ),
                  ),
                ],
              ),
              SizedBox(height: AspectRatios.height * 0.01),
              buildPodiumSection(
                items: [
                  {'content': "assets/images/FireFly_Logo.png"},
                  {'content': "assets/images/_4chicks_logo.png"},
                  {'content': "assets/images/CloudShot_logo.png"},
                ],
              ),
              SizedBox(height: AspectRatios.height * 0.01),
              Center(
                child: SmoothPageIndicator(
                  controller: pageController, 
                  count: 5, // Number of items in the PageView
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color.fromARGB(255, 255, 196, 45),
                    dotHeight: 4,
                    dotWidth: 8,
                  ), // Dots style
                ),
              ),
              // Rating Experts Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rating Experts',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentCategory, // Display the current category
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Optional: add color for distinction
                    ),
                  ),
                ],
              ),
              SizedBox(height: AspectRatios.height * 0.01),
              buildPodiumSection(
                items: [
                  {'content': "assets/images/mhmd_adass.png"},
                  {'content': "assets/images/mhmd_adass.png"},
                  {'content': "assets/images/mhmd_adass.png"},
                ],
              ),
              SizedBox(height: AspectRatios.height * 0.01),
              // Dots for section change
              Center(
                child: SmoothPageIndicator(
                  controller: pageController, 
                  count: 5, // Number of items in the PageView
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color.fromARGB(255, 255, 196, 45),
                    dotHeight: 4,
                    dotWidth: 8,
                  ), // Dots style
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(), // Use NavigationBarWidget here
    );
  }

  // Function to create the Categories Section
  Widget buildCategoriesSection(double screenWidth, double screenHeight) {
    const categories = [
      {'icon': 'assets/icons/serviceis_icon.svg'},
      {'icon': 'assets/icons/food_icon.svg'},
      {'icon': 'assets/icons/clothes_icon.svg'},
      {'icon': 'assets/icons/educations_icon.svg'},
      {'icon': 'assets/icons/cars_icon.svg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: screenWidth * 0.05,
          runSpacing: screenHeight * 0.02,
          alignment: WrapAlignment.start,
          children: categories.map((category) {
            return SizedBox(
              width: screenWidth * 0.18,
              child: Column(
                children: [
                  SvgPicture.asset(
                    category['icon'] as String,
                    height: screenHeight * 0.067,
                    width: screenWidth * 0.05,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Function to create each section
  Widget buildPodiumSection({
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      height: AspectRatios.height * 0.129,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 196, 45), // Yellow background
        borderRadius: BorderRadius.circular(25),
      ),
      child: PageView.builder(
        controller: pageController,
        itemCount: 5, // Number of podium items
        onPageChanged: (int page) {
          setState(() {
            currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildPodiumItemWithContainer(
                content: items[0]['content'],
                text: "2nd",
                height: AspectRatios.height * 0.05,
              ),
              SizedBox(width: AspectRatios.width * 0.1),
              buildPodiumItemWithContainer(
                content: items[1]['content'],
                text: "1st",
                height: AspectRatios.height * 0.07,
              ),
              SizedBox(width: AspectRatios.width * 0.1),
              buildPodiumItemWithContainer(
                content: items[2]['content'],
                text: "3rd",
                height: AspectRatios.height * 0.025,
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to build each podium item
  Widget buildPodiumItemWithContainer({
    required dynamic content, // Can be IconData, ImageProvider, or String
    required String text,
    required double height,
  }) {
    Widget contentWidget;

    // Always use CircleAvatar with images (could be SVG or PNG)
    contentWidget = CircleAvatar(
      radius: AspectRatios.height * 0.028,
      backgroundImage: AssetImage(content),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        contentWidget,
        Container(
          padding: const EdgeInsets.all(0),
          height: height, // Dynamic height for each container
          width: AspectRatios.width * 0.17,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}