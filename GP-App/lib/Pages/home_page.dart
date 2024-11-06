import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/dialogs/nav_bar.dart';
import 'package:rates/constants/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

// Style for titles in the the finests
const TextStyle titleStyle = TextStyle(
  color: Color.fromRGBO(0, 0, 0, 1),
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

class HomePageState extends State<HomePage> {
  int selectedIndex =
      0; // Index to track the selected item in the bottom navigation bar
  final List<String> pageTitles = [
    'Categories',
    'Food',
    'Profile'
  ]; // Titles for pages in the navigation bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:
          const NavBar(), // Drawer menu that opens from the end (right side)
      backgroundColor: const Color.fromRGBO(48, 48, 48, 1), // Background color of the app

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 196, 154),
        title: Text(
          pageTitles[
              selectedIndex], // Display title based on selected index frm the bottom bar
          style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        centerTitle: true,
        actions: [
          // Icon button to open the drawer
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                color: const Color.fromRGBO(0, 0, 0, 1),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Opens the end drawer
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity, // Ensures the image covers the full width
        height: double.infinity, // Ensures the image covers the full height
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/Horizontal_background.png'), // Path to your image
            fit: BoxFit.cover, // Ensures the image covers the entire area
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Section to display "Monthly Finest" items
            buildFinest(
              'Monthly Finest',
              ['FireFly', 'Shwarma3Saj', '4chicks'],
              ['assets/images/FireFly_Logo.png', 'assets/images/SawermaSaj_logo.png', 'assets/images/_4chicks_logo.png'],
              () {
                Navigator.of(context)
                    .pushNamed(shopsRoute); // Navigate to shops route on tap
              },
            ),
            // Section to display "Yearly Finest" items
            buildFinest(
              'Yearly Finest',
              ['FireFly', 'MeatMoot', 'BurgarMaker'],
              ['assets/images/FireFly_Logo.png', 'assets/images/MeatMoot_Logo.jpeg', 'assets/images/BurgarMaker_Logo.jpeg'],
              () {
                Navigator.of(context)
                    .pushNamed(shopsRoute); // Navigate to shops route on tap
              },
            ),
            // Section to display "Rating Experts" items
            buildFinest(
              'Rating Experts',
              ['Mhmd', 'Baraa', 'Bashar'],
              [
                'assets/images/mhmd_adass.png',
                'assets/images/Bara.jpeg',
                'assets/images/Bashar_Akileh.jpg'
              ],
              () {
                // Navigate to Rating Experts route on tap
              },
            ),
            // Button to rating
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 244, 143, 66), // Orange button

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
      ),
      // Bottom navigation bar with three items
      bottomNavigationBar: NavigationBar(
          backgroundColor: const Color.fromARGB(255, 255, 196, 154),
          height: AspectRatios.height * 0.07,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "home"),
            NavigationDestination(icon: Icon(Icons.face), label: "test"),
            NavigationDestination(icon: Icon(Icons.menu), label: "menu"),
          ]),
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
    double containerHeight =
        AspectRatios.height * 0.20; // Set container height based on screen size
    double avatarSize =
        containerHeight * 0.16; // Set avatar size based on container height

    return GestureDetector(
      onTap: onTap, // Detect tap on the container
      child: Container(
        width: AspectRatios.width,
        height: containerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.8), // Semi-transparent background
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(51, 0, 0, 0), // Subtle shadow effect
              blurRadius: 5.0,
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
                  padding: EdgeInsets.only(top: containerHeight * 0.15),
                  child: buildAvatarAndName(
                      finestNames[1], finestPics[1], avatarSize, 2),
                ),
                // First avatar (Gold)
                Padding(
                  padding: EdgeInsets.only(bottom: containerHeight * 0.5),
                  child: buildAvatarAndName(
                      finestNames[0], finestPics[0], avatarSize, 1,
                      showCrown: true),
                ),
                // Third avatar (Bronze)
                Padding(
                  padding: EdgeInsets.only(top: containerHeight * 0.4),
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
                  right: radius * -0.34,
                  child: Transform.rotate(
                    angle: radius * 0.034,
                    child: Image.asset(
                      'assets/images/golden_crown.png',
                      color: const Color.fromRGBO(255, 193, 7, 1),
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
                    ? const Color.fromARGB(255, 255, 193, 7)
                    : rank == 2
                        ? const Color.fromRGBO(158, 158, 158, 1)
                        : const Color.fromRGBO(121, 85, 72, 1), // Set color based on rank
                size: radius * 0.7,
              ),
              Text(
                name,
                style: const TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
