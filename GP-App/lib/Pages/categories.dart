import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart'; // Imports Flutter's material design widgets.
import 'package:rates/Pages/shops_page.dart';

class Categories extends StatefulWidget {
  const Categories(
      {super.key}); // Constructor for Categories, using super.key to maintain key functionality.

  @override
  State<Categories> createState() =>
      _CategoriesState(); // Creates the state for the Categories widget.
}

// Defines the state class for the Categories widget.
class _CategoriesState extends State<Categories> {
  // List of image paths for the carousel slider.
  final List<String> imgList = [
    'assets/images/_4chicks_logo.png',
    'assets/images/BurgarMaker_Logo.jpeg',
    'assets/images/FireFly_Logo.png',
    'assets/images/MeatMoot_Logo.jpeg',
    'assets/images/BurgarMaker_Logo.jpeg',
  ];

  int currentIndex =
      0; // Tracks the currently selected bottom navigation index.
  bool IsSearch = false; // Tracks whether the search bar is active.
  final TextEditingController SearchConroller =
      TextEditingController(); // Controller for managing the search input.

  @override
  Widget build(BuildContext context) {
    // Builds the overall layout of the Categories page.
    return Scaffold(
      appBar: appbar_Bulid(), // Creates the app bar using a helper method.
      body: BulidBody(), // Creates the body of the page using a helper method.
      bottomNavigationBar:
          BulidNavigationBar(), // Creates the bottom navigation bar using a helper method.
    );
  }

  AppBar appbar_Bulid() {
    // Builds the app bar with search functionality.
    return AppBar(
      backgroundColor: const Color.fromARGB(
          150, 244, 143, 66), // Sets the app bar background color to white.
      leading: IconButton(
        icon: const Icon(Icons.arrow_back), // Back button icon.
        onPressed: () => Navigator.of(context)
            .pop(), // Pops the current route off the navigator stack.
      ),
      title: IsSearch
          ? BulidSearchField()
          : const Text(
              'RATES'), // Displays search field or title based on IsSearch state.
      actions: [
        IconButton(
          icon: const Icon(Icons.search), // Search icon.
          onPressed: () {
            setState(() {
              IsSearch = !IsSearch; // Toggles the search mode.
              if (!IsSearch)
                SearchConroller
                    .clear(); // Clears the search input if exiting search mode.
            });
          },
        ),
      ],
    );
  }

  TextField BulidSearchField() {
    // Builds the search field.
    return TextField(
      controller: SearchConroller, // Binds the search field to the controller.
      autofocus: true, // Automatically focuses on the search field when opened.
      decoration: const InputDecoration(
        hintText: 'Search...', // Placeholder text in the search field.
        border: InputBorder.none, // No border for the search field.
      ),
      onSubmitted: (value) {
        // Handles the search submission.
        print("Search for: $value"); // Prints the submitted search value.
      },
    );
  }

  Widget BulidBody() {
    // Constructs the main body of the Categories page.
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/Horizontal_background.png'), // Specify your image path here
          fit: BoxFit.cover, // This will cover the entire container
        ),
      ),
      child: SingleChildScrollView(
        // Allows the body to scroll if content exceeds screen height.
        child: Column(
          children: [
            BulidCarouselSlider(), // Builds the image carousel slider.
            const SizedBox(height: 10), // Adds vertical space.
            Label(), // Displays the categories label.
            const SizedBox(height: 20), // Adds vertical space.
            FoodContainers(), // Builds a food category container.
            const SizedBox(height: 20), // Adds vertical space.
            BuidGridCategory(), // Builds a grid of category items.
          ],
        ),
      ),
    );
  }

  CarouselSlider BulidCarouselSlider() {
    // Builds the carousel slider for images.
    final totalHeight = MediaQuery.of(context)
        .size
        .height; // Gets the total height of the screen.
    return CarouselSlider(
      options: CarouselOptions(
        height: totalHeight *
            0.25, // Sets the height of the carousel to 25% of the screen height.
        autoPlay: true, // Enables automatic playback of carousel.
        autoPlayInterval: const Duration(
            seconds: 3), // Sets interval between slides to 5 seconds.
        autoPlayAnimationDuration: const Duration(
            milliseconds: 800), // Sets the animation duration for sliding.
        pauseAutoPlayOnTouch:
            true, // Pauses autoplay when the user interacts with the carousel.
      ),
      items: imgList
          .map((imgPath) => carouselItems(imgPath))
          .toList(), // Maps image paths to carousel items.
    );
  }

  Container carouselItems(String imgPath) {
    // Builds each item in the carousel slider.
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 5.0), // Adds horizontal margin.
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imgPath), // Loads the image from assets.
          fit: BoxFit.fill, // Fills the container with the image.
        ),
      ),
    );
  }

  Text Label() {
    // Builds the label for categories.
    return const Text(
      'CATEGORIES',
      style: TextStyle(
          fontSize: 20, // Sets font size.
          fontWeight: FontWeight.bold, // Makes the font bold.
          color: Colors.black), // Sets text color to white.
    );
  }

  GestureDetector FoodContainers() {
    // Builds a container for the Food category.
    return GestureDetector(
      onTap: () => OpenPage(
          const ShopsPage()), // Navigates to the ShopsPage page when tapped.
      child: FoodCategoryContainer(Icons.fastfood,
          'Food'), // Builds the category container with food icon and label.
    );
  }

  Widget BuidGridCategory() {
    // Builds a grid of various category items.
    return GridView.count(
      crossAxisCount: 2, // Sets the number of columns in the grid to 2.
      shrinkWrap: true, // Allows the grid to take up only the necessary space.
      physics:
          const NeverScrollableScrollPhysics(), // Prevents scrolling in the grid.
      padding: const EdgeInsets.all(20), // Adds padding around the grid.
      children: [
        BulidGridContainers(
            Icons.school,
            'Education',
            Dialog.fullscreen(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center horizontally
                children: [
                  appbar_Bulid(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Coming soon",
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ],
              ),
            )),
// Education grid item.
        BulidGridContainers(
            Icons.build,
            'Services',
            Dialog.fullscreen(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center horizontally
                children: [
                  appbar_Bulid(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Coming soon",
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ],
              ),
            )), // Services grid item.
        BulidGridContainers(
            Icons.directions_car,
            'Cars',
            Dialog.fullscreen(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center horizontally
                children: [
                  appbar_Bulid(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Coming soon",
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ],
              ),
            )), // Cars grid item.
        BulidGridContainers(
            Icons.accessibility_sharp,
            'Clothes',
            Dialog.fullscreen(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center horizontally
                children: [
                  appbar_Bulid(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Coming soon",
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ],
              ),
            )), // Clothes grid item.
      ],
    );
  }

  GestureDetector BulidGridContainers(
      IconData icon, String label, Widget page) {
    // Builds a grid item for each category.
    return GestureDetector(
      onTap: () =>
          OpenPage(page), // Navigates to the corresponding page when tapped.
      child: FoodCategoryContainer(
          icon, label), // Builds the category container for the grid item.
    );
  }

  Container FoodCategoryContainer(IconData icon, String label) {
    // Builds a reusable container food container.
    final totalHeight = MediaQuery.of(context)
        .size
        .height; // Gets the total height of the screen.
    final totalWidth = MediaQuery.of(context)
        .size
        .width; // Gets the total width of the screen.
    return Container(
      width: totalWidth *
          0.9, // Sets the container width to 90% of the screen width.
      height: totalHeight *
          0.19, // Sets the container height to 16% of the screen height.
      margin: const EdgeInsets.all(10), // Adds margin around the container.
      padding: const EdgeInsets.all(20), // Adds padding inside the container.
      decoration: BoxDecoration(
        color: Colors.white, // Sets the background color with transparency.
        borderRadius:
            BorderRadius.circular(10), // Rounds the corners of the container.
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centers the content vertically.
        children: [
          Icon(icon,
              size: 40, color: Colors.black), // Displays the category icon.
          const SizedBox(height: 10), // Adds vertical space.
          Text(
            label,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16), // Displays the category label.
          ),
        ],
      ),
    );
  }

  void OpenPage(Widget page) {
    // Navigates to a specified page.
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            page)); // Pushes the new page onto the navigation stack.
  }

  BottomNavigationBar BulidNavigationBar() {
    // Builds the bottom navigation bar.
    return BottomNavigationBar(
      onTap: (val) {
        setState(() {
          currentIndex =
              val; // Updates the currently selected index when an item is tapped.
        });
      },
      backgroundColor: const Color.fromARGB(150, 244, 143,
          66), // Sets the background color of the navigation bar to black.
      selectedItemColor:
          Colors.white, // Sets the color of the selected item to white.
      unselectedItemColor: Colors.black, // Sets the color of unselected items.
      selectedFontSize: 15.0, // Sets font size for selected item label.
      unselectedFontSize: 10, // Sets font size for unselected item label.
      selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold), // Makes selected item label bold.
      currentIndex: currentIndex, // Sets the currently selected index.
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // Icon for the Categories tab.
          label: 'Home', // Label for the home tab.
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.face), // Icon for the Food tab.
          label: 'Test', // Label for the test tab.
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu), // Icon for the Profile tab.
          label: 'menu', // Label for the Profile tab.
        ),
      ],
    );
  }
}
