import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rates/dialogs/redeem_dialog.dart';

class BottomNavController extends GetxController {
  var currentIndex = 2.obs; // Reactive variable for the selected index

  void changePage(int index) {
    currentIndex.value = index;
  }
}

class NavigationBarWidget extends StatelessWidget {
  NavigationBarWidget({super.key});

  // Access the BottomNavController
  final BottomNavController bottomNavController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: bottomNavController.currentIndex.value, // Reactive index
          onTap: (index) {
            if (index != 0) {
              bottomNavController.changePage(index); // Call changePage method
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const VerificationDialogPage(); // Show the verification dialog
                },
              );
            }
          },
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900] // Dark mode background
              : Colors.white, // Light mode background
          selectedItemColor: Theme.of(context).colorScheme.primary, // Dynamic color based on theme
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0), // Dynamic color
          selectedLabelStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[900], // White in dark theme and black in light theme
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0)
                : Colors.black.withOpacity(0), // Adjust opacity for unselected labels
          ),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/rate_icon.svg',
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black, // Icon color based on theme
              ),
              label: 'Rate',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/profile_icon.svg',
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black, // Icon color based on theme
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home_icon.svg',
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black, // Icon color based on theme
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/favorite_icon.svg',
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black, // Icon color based on theme
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/about_icon.svg',
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black, // Icon color based on theme
              ),
              label: 'About',
            ),
          ],
        ));
  }
}
