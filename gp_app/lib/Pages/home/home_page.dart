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
  PageController pageController =
  PageController(); // Page controller for the swiping
  int currentPage = 0; // Current page for the indicator
  bool showVerificationMessage = true; // Controls the verification message
  bool emailVerified = false; // Controls the success message

  void showSuccessMessage() {
    setState(() {
      emailVerified = true; // Show the success message
    });

    // Automatically hide success message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        emailVerified = false; // Hide the success message
      });
    });
  }

  void showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Verify Email"),
        content: const Text("Are you sure you want to verify your email?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                showVerificationMessage =
                    false; // Hide the verification message
              });
              showSuccessMessage(); // Trigger the success message
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/logos/black_logo.svg',
          height: AspectRatios.height * 0.03865213082259663032705649157582,
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
              // Conditional Messages
              if (showVerificationMessage)
                Container(
                  height: AspectRatios.height*0.03030303030303030303030303030303,
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(bottom: 4.0),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 158, 158, 158).withOpacity(0.2), // Light background color
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.info_outline, color: Color.fromARGB(255, 0, 0, 0)),
                        onPressed: showVerificationDialog, // Show the dialog
                        iconSize: AspectRatios.height*0.01955034213098729227761485826002,
                      ),
                      const Text(
                        "Please verify your email.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                )
              else if (emailVerified)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    margin: const EdgeInsets.only(bottom: 4.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 76, 175, 80)
                          .withOpacity(0.2), // Light green background
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Text(
                      "Email is verified successfully.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
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
                          color: const Color.fromARGB(255, 238, 238, 238),
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
                                color: Color.fromARGB(221, 0, 0, 0)),
                            color: const Color.fromARGB(255, 255, 255,
                                255), // Background color of the popup menu
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
                                    color: Color.fromARGB(
                                        221, 0, 0, 0), // Text color
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
                                    color: Color.fromARGB(221, 0, 0, 0),
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
                                    color: Color.fromARGB(221, 0, 0, 0),
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
                                    color: Color.fromARGB(221, 0, 0, 0),
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
                                    color: Color.fromARGB(221, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                              side: const BorderSide(
                                color: Color.fromARGB(
                                    255, 224, 224, 224), // Light grey border
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
                      color: Color.fromARGB(255, 158, 158,
                          158), // Optional: add color for distinction
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
                  effect: ExpandingDotsEffect(
                    activeDotColor: const Color.fromARGB(255, 255, 196, 45),
                    dotHeight: AspectRatios.height * 0.005,
                    dotWidth: AspectRatios.height * 0.01,
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
                      color: Color.fromARGB(255, 158, 158,
                          158), // Optional: add color for distinction
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
                  effect: ExpandingDotsEffect(
                    activeDotColor: const Color.fromARGB(255, 255, 196, 45),
                    dotHeight: AspectRatios.height * 0.005,
                    dotWidth: AspectRatios.height * 0.01,
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
                      color: Color.fromARGB(255, 158, 158,
                          158), // Optional: add color for distinction
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
                  effect: ExpandingDotsEffect(
                    activeDotColor: const Color.fromARGB(255, 255, 196, 45),
                    dotHeight: AspectRatios.height * 0.005,
                    dotWidth: AspectRatios.height * 0.01,
                  ), // Dots style
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          NavigationBarWidget(), // Use NavigationBarWidget here
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
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: SvgPicture.asset(
                  category['icon'] as String,
                  height: screenHeight * 0.0594648166501486620416253716551,
                  width: screenWidth * 0.04360753221010901883052527254708,
                ),
                onPressed: () {},
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (text == "1st")
                  SvgPicture.asset(
                    'assets/icons/Crown.svg',
                    height: AspectRatios.height * 0.033,
                  ),
                Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
