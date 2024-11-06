import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/dialogs/nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Style for titles in the the finests
const TextStyle titleStyle = TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0; // Index to track the selected item in the bottom navigation bar
  final List<String> pageTitles = ['Categories', 'Food', 'Profile']; // Titles for pages in the navigation bar

  @override
  Widget build(BuildContext context) {
    double bottomAppBarHeight = AspectRatios.height * 0.08; // Set the height of the bottom app bar

    return Scaffold(
      endDrawer: const NavBar(), // Drawer menu that opens from the end (right side)
      backgroundColor: Colors.grey[850], // Background color of the app
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          pageTitles[selectedIndex], // Display title based on selected index frm the bottom bar
          style: const TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
        actions: [
          // Icon button to open the drawer
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                color: Colors.amber,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Opens the end drawer
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Section to display "Monthly Finest" items
          buildFinest(
            'Monthly Finest',
            ['FireFly', 'Shwarma3Saj', 'Nar Snack'],
            ['assets/logo1.png', 'assets/logo2.png', 'assets/logo3.png'],
            () {
            //  Navigator.of(context).pushNamed(Routes.shopsRoute); // Navigate to shops route on tap
            },
          ),
          // Section to display "Yearly Finest" items
          buildFinest(
            'Yearly Finest',
            ['FireFly', 'Shwarma3Saj', 'Nar Snack'],
            ['assets/logo1.png', 'assets/logo2.png', 'assets/logo3.png'],
            () {
              // Navigate to Yearly Finest route on tap
            },
          ),
          // Section to display "Rating Experts" items
          buildFinest(
            'Rating Experts',
            ['Mhmd', 'Baraa', 'Bashar'],
            ['assets/logo1.png', 'assets/logo2.png', 'assets/logo3.png'],
            () {
              // Navigate to Rating Experts route on tap
            },
          ),
          // Button to rating
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: AspectRatios.width * 0.4,
                vertical: AspectRatios.height * 0.01,
              ),
            ),
            child: const Text(
              'Rate',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      // Bottom navigation bar with three items
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: bottomAppBarHeight,
          child: BottomAppBar(
            color: Colors.grey[850],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Bottom navigation item for "Categories"
                buildBottomNavItem(
                    Icons.category_outlined, 0, bottomAppBarHeight),
                // Bottom navigation item for "Food"
                buildBottomNavItem(
                    Icons.fastfood_outlined, 1, bottomAppBarHeight),
                // Bottom navigation item for "Profile"
                buildBottomNavItem(
                    Icons.person_pin_outlined, 2, bottomAppBarHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for bottom navigation bar items
  Widget buildBottomNavItem(IconData icon, int index, double height) {
    bool isActive = selectedIndex == index; // Check if the item is active
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? Colors.amberAccent : Colors.white, // Change color based on active state
        size: isActive ? AspectRatios.height * 0.05 : AspectRatios.height * 0.03, // Change size based on active state
      ),
      onPressed: () {
        setState(() {
          selectedIndex = index; // Update the selected index on tap
        });
      },
    );
  }

  // Builds a section displaying "finest" items (Monthly, Yearly)
  Widget buildFinest(
      String title, List<String> names, List<String> pics, VoidCallback onTap) {
    return Column(
      children: [
        Text(
          title,
          style: titleStyle, 
        ),
        TheFinest(
          finestNames: names, // List of names
          finestPics: pics, // List of image paths
          onTap: onTap, // Action on tap
        ),
      ],
    );
  }
}

// widget to display a row of "finest" items 
class TheFinest extends StatelessWidget {
  final List<String> finestNames; // List of names for avatars
  final List<String> finestPics; // List of image paths for avatars
  final VoidCallback onTap; // Tap action for the each container

  const TheFinest({
    super.key,
    required this.finestNames,
    required this.finestPics,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double containerHeight = AspectRatios.height * 0.20; // Set container height based on screen size
    double avatarSize = containerHeight * 0.15; // Set avatar size based on container height

    return GestureDetector(
      onTap: onTap, // Detect tap on the container
      child: Container(
        width: AspectRatios.width,
        height: containerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[850]!.withOpacity(0.5), // Background color with opacity for the containers
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
              offset: Offset(1.0, 1.0), // Shadow effect
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            // Row to display three avatars (second, first, third place) with padding to position them in a podium
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Second avatar (Silver)
                Padding(
                  padding: EdgeInsets.only(
                      top: containerHeight * 0.15),
                  child: buildAvatarAndName(
                      finestNames[1], finestPics[1], avatarSize, 2),
                ),
                // First avatar (Gold)
                Padding(
                  padding: EdgeInsets.only(bottom: containerHeight * 0.5),
                  child: buildAvatarAndName(finestNames[0], finestPics[0], avatarSize, 1,
                      showCrown: true),
                ),
                // Third avatar (Bronze)
                Padding(
                  padding: EdgeInsets.only(
                      top: containerHeight * 0.4), 
                  child: buildAvatarAndName(
                      finestNames[2], finestPics[2], avatarSize, 3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Builds an avatar with name and rank icon 
  Widget buildAvatarAndName(String name, String logo, double radius, int rank,
      {bool showCrown = false}) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          // Stack to overlay crown on avatar if necessary
          Stack(
            children: [
              // Avatar image with padding (so that the crown fits on the avatar)
              Padding(
                padding: EdgeInsets.all(radius * 0.2),
                child: CircleAvatar(
                  backgroundImage: AssetImage(logo),
                  radius: radius,
                ),
              ),
              // Crown image positioned above the avatar (if showCrown is true)
              if (showCrown)
                Positioned(
                  top: radius * -0.2,
                  right: radius * -0.3,
                  child: Transform.rotate(
                    angle: radius * 0.037,
                    child: Image.asset(
                      'assets/images/golden_crown.png',
                      color: Colors.amber,
                      width: radius * 1.25,
                      height: radius * 1.25,
                    ),
                  ),
                ),
            ],
          ),
          // Row with star icon and name below avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: rank == 1
                    ? Colors.amber
                    : rank == 2
                        ? Colors.grey
                        : Colors.brown, // Set color based on rank
                size: radius * 0.7,
              ),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
