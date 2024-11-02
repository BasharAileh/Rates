import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/pop_ups/nav_bar.dart';
import 'dart:developer' as devtools show log;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<String> pageTitles = ['Categories', 'Food', 'Profile'];

  @override
  Widget build(BuildContext context) {
    double bottomAppBarHeight = AspectRatios.height * 0.07;
    return Scaffold(
      endDrawer: const NavBar(),
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          pageTitles[selectedIndex],
          style: const TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Monthly Finest',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          TheFinest(
            finestNames: const ['FireFly', 'Shwarma3Saj', 'Nar Snack'],
            finestPics: const [
              'assets/logo1.png',
              'assets/logo2.png',
              'assets/logo3.png'
            ],
            onTap: () {
              Navigator.of(context).pushNamed(Routes.shopsRoute);
            },
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Yearly Finest',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          TheFinest(
            finestNames: const ['FireFly', 'Shwarma3Saj', 'Nar Snack'],
            finestPics: const [
              'assets/logo1.png',
              'assets/logo2.png',
              'assets/logo3.png'
            ],
            onTap: () {
              // Navigate to Yearly Finest details page
            },
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Rating Experts',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          TheFinest(
            finestNames: const ['Mhmd', 'Baraa', 'Bashar'],
            finestPics: const [
              'assets/logo1.png',
              'assets/logo2.png',
              'assets/logo3.png'
            ],
            onTap: () {
              // Navigate to Rating Experts details page
            },
          ),
          Container(
            padding: const EdgeInsets.all(0.1),
            child: ElevatedButton(
              onPressed: () {
                // Handle Rate button press
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(
                    horizontal: AspectRatios.width * 0.4,
                    vertical: AspectRatios.height * 0.01),
              ),
              child: const Text(
                'Rate',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: bottomAppBarHeight,
          child: BottomAppBar(
            color: Colors.grey[850],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildBottomNavItem(
                    Icons.category_outlined, 0, bottomAppBarHeight),
                buildBottomNavItem(
                    Icons.fastfood_outlined, 1, bottomAppBarHeight),
                buildBottomNavItem(
                    Icons.person_pin_outlined, 2, bottomAppBarHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavItem(IconData icon, int index, double height) {
    bool isActive = selectedIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? Colors.amberAccent : Colors.white,
        size: isActive ? height * 0.6 : height * 0.4,
      ),
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}

class TheFinest extends StatelessWidget {
  final List<String> finestNames;
  final List<String> finestPics;
  final VoidCallback onTap;

  const TheFinest({
    super.key,
    required this.finestNames,
    required this.finestPics,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double bottomAppBarHeight = AspectRatios.height * 0.07;
    double containerHeight =
        ((AspectRatios.height - appBarHeight) - bottomAppBarHeight) * 0.21;
    double avatarSize = containerHeight * 0.15;
    double orderRadius = 20;

    return Container(
      width: AspectRatios.width,
      height: containerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(orderRadius),
        color: Colors.grey[850],
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
      margin: const EdgeInsets.all(15.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildPyramidWithAvatars(finestNames, finestPics, avatarSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPyramidWithAvatars(
      List<String> names, List<String> pics, double avatarRadius) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAvatarAndName(names[0], pics[0], avatarRadius, 1,
                showCrown: true),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildAvatarAndName(names[1], pics[1], avatarRadius, 2),
            buildAvatarAndName(names[2], pics[2], avatarRadius, 3),
          ],
        ),
      ],
    );
  }

  Widget buildAvatarAndName(String name, String logo, double radius, int rank,
      {bool showCrown = false}) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(radius * 0.2),
              child: CircleAvatar(
                backgroundImage: AssetImage(logo),
                radius: radius,
              ),
            ),
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
        Row(
          children: [
            Icon(
              Icons.star,
              color: rank == 1
                  ? Colors.amber
                  : rank == 2
                      ? Colors.grey
                      : Colors.brown,
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
    );
  }
}
