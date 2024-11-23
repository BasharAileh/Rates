import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rates/dialogs/nav_contoller.dart';


class NavigationBarWidget extends StatelessWidget {
  NavigationBarWidget({super.key});

  // Access the BottomNavController
  final BottomNavController bottomNavController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: bottomNavController.currentIndex.value, // Reactive index
          onTap: (index) {
            bottomNavController.changePage(index); // Call changePage method
          },
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/rate_icon.svg'),
              label: 'Rate',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/profile_icon.svg'),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/home_icon.svg'),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/favorite_icon.svg'),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/about_icon.svg'),
              label: 'About',
            ),
          ],
        ));
  }
}
