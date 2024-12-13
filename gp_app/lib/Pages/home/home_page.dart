import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'dart:developer' as devtools show log;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import smooth page indicator

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> categoriess = [
    "Food",
    "Services",
    "Cloths",
    "Education",
    "Cars"
  ]; // Add categories
  String mainCurrentCategoryTitle = "Food";
  String mfCurrentCategoryTitle = "Food";
  String yfCurrentCategoryTitle = "Food";
  String reCurrentCategoryTitle = "Food";
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
          height: AspectRatios.height * 0.04747826086956521739130434782609,
          width: AspectRatios.width * 0.14871794871794871794871794871795,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Conditional Messages
            if (showVerificationMessage)
              GestureDetector(
                onTap: showVerificationDialog, // Show the dialog
                child: Container(
                  height:
                      AspectRatios.height * 0.03757575757575757575757575757576,
                  width:
                      AspectRatios.width * 0.91384615384615384615384615384615,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 158, 158, 158)
                        .withOpacity(0.2), // Light background color
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        size: AspectRatios.height *
                            0.02424242424242424242424242424242,
                      ),
                      SizedBox(width: AspectRatios.width * 0.01),
                      const Text(
                        "Please verify your email.",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (emailVerified)
              Center(
                child: Container(
                  height:
                      AspectRatios.height * 0.03757575757575757575757575757576,
                  width:
                      AspectRatios.width * 0.91384615384615384615384615384615,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(25, 76, 175, 80)
                        .withOpacity(0.1), // Light background color
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Email is verified successfully.",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 76, 175, 80),
                        ),
                      ),
                      SizedBox(width: AspectRatios.width * 0.01),
                      SvgPicture.asset(
                        'assets/icons/shield.svg',
                        height: AspectRatios.height *
                            0.02545454545454545454545454545455,
                        width: AspectRatios.width *
                            0.05384615384615384615384615384615,
                      ),
                    ],
                  ),
                ),
              ),
            // Categories Section
            buildCategoriesSection(),
            // Top Rated Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Rated',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 202, 196, 208),
                            width: 1.0,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          )),
                      child: Text(
                        mainCurrentCategoryTitle,
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
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          elevation: 4, // Slight shadow for depth
                          onSelected: (String value) {
                            setState(() {
                              mainCurrentCategoryTitle = value;
                              mfCurrentCategoryTitle = value;
                              yfCurrentCategoryTitle = value;
                              reCurrentCategoryTitle = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              categoriess.map((String category) {
                            return PopupMenuItemBuilder.build(value: category);
                          }).toList(),
                        )),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                FinestSection(
                  title: 'Monthly Finest',
                  currentCategory: mfCurrentCategoryTitle,
                  items: const [
                    {'content': "assets/images/FireFly_Logo.png"},
                    {'content': "assets/images/_4chicks_logo.png"},
                    {'content': "assets/images/CloudShot_logo.png"},
                  ],
                  categoriess: categoriess,
                ),
                FinestSection(
                  title: 'Yearly Finest',
                  currentCategory: yfCurrentCategoryTitle,
                  items: const [
                    {'content': "assets/images/FireFly_Logo.png"},
                    {'content': "assets/images/_4chicks_logo.png"},
                    {'content': "assets/images/CloudShot_logo.png"},
                  ],
                  categoriess: categoriess,
                ),
                FinestSection(
                  title: 'Rating Experts',
                  currentCategory: reCurrentCategoryTitle,
                  items: const [
                    {'content': "assets/images/mhmd_adass.png"},
                    {'content': "assets/images/mhmd_adass.png"},
                    {'content': "assets/images/mhmd_adass.png"},
                  ],
                  categoriess: categoriess,
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  // Function to create the Categories Section
  Widget buildCategoriesSection() {
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
          spacing: AspectRatios.width * 0.05,
          runSpacing: AspectRatios.height * 0.02,
          alignment: WrapAlignment.start,
          children: categories.map((category) {
            return SizedBox(
              width: AspectRatios.width * 0.18,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: SvgPicture.asset(
                  category['icon'] as String,
                  height:
                      AspectRatios.height * 0.0594648166501486620416253716551,
                  width:
                      AspectRatios.width * 0.04360753221010901883052527254708,
                ),
                onPressed: () {},
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FinestSection extends StatefulWidget {
  final String title;
  String currentCategory;
  final List<Map<String, String>> items;
  final List<String> categoriess;

  FinestSection({
    super.key,
    required this.title,
    required this.currentCategory,
    required this.items,
    required this.categoriess,
  });

  @override
  State<FinestSection> createState() => _FinestSectionState();
}

class _FinestSectionState extends State<FinestSection> {
  late PageController pageController; // Local PageController for this section
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(); // Initialize the PageController
  }

  @override
  void dispose() {
    pageController.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.currentCategory,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 158, 158, 158),
              ),
            ),
          ],
        ),
        SizedBox(height: AspectRatios.height * 0.01),
        buildPodiumSection(items: widget.items), // Call the podium section here
        SizedBox(height: AspectRatios.height * 0.01),
        Center(
          child: SmoothPageIndicator(
            controller: pageController,
            count: widget.categoriess.length,
            effect: ExpandingDotsEffect(
              activeDotColor: const Color.fromARGB(255, 255, 196, 45),
              dotHeight: AspectRatios.height * 0.005,
              dotWidth: AspectRatios.height * 0.01,
            ),
          ),
        ),
      ],
    );
  }

  // Function to build each podium section
  Widget buildPodiumSection({
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      height: AspectRatios.height * 0.14424242424242424242424242424242,
      width: AspectRatios.width * 0.91384615384615384615384615384615,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color.fromARGB(255, 243, 198, 35),
            Color.fromARGB(255, 255, 166, 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.1, 1.0],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: PageView.builder(
        controller: pageController,
        itemCount: widget.categoriess.length,
        onPageChanged: (int page) {
          setState(() {
             currentPage = page;
            widget.currentCategory = widget.categoriess[page];
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
                height: AspectRatios.height * 0.057,
              ),
              SizedBox(width: AspectRatios.width * 0.1),
              buildPodiumItemWithContainer(
                content: items[1]['content'],
                text: "1st",
                height: AspectRatios.height * 0.08,
              ),
              SizedBox(width: AspectRatios.width * 0.1),
              buildPodiumItemWithContainer(
                content: items[2]['content'],
                text: "3rd",
                height: AspectRatios.height * 0.035,
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to build each podium item
  Widget buildPodiumItemWithContainer({
    required dynamic content,
    required String text,
    required double height,
  }) {
    Widget contentWidget;

    contentWidget = CircleAvatar(
      radius: AspectRatios.height * 0.028,
      backgroundImage: AssetImage(content),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        contentWidget,
        SizedBox(height: AspectRatios.height * 0.0039),
        Container(
          height: height,
          width: AspectRatios.width * 0.15,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
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
              ]
          ),
        ),)
      ],
    );
  }
}

class PopupMenuItemBuilder {
  static PopupMenuItem<String> build({
    required String value,
  }) {
    return PopupMenuItem<String>(
      height: AspectRatios.height * 0.05,
      value: value,
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(221, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
