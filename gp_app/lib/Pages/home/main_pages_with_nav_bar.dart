import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/Pages/home/home_page.dart';
import 'package:rates/Pages/other/favorites_page.dart';
import 'package:rates/Pages/other/profile_page.dart';
import 'package:rates/Pages/registration/login_page.dart';
import 'package:rates/Pages/registration/signup_page.dart';
import 'package:rates/dialogs/nav_bar.dart';

class PagesWithNavBar extends StatelessWidget {
  late final int page;

  PagesWithNavBar({super.key, this.page = 5});

  final BottomNavController bottomNavController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page == 5
          ? Obx(() {
              // Dynamically load the page based on the selected index
              switch (bottomNavController.currentIndex.value) {
                case 0:
                  return HomePage();
                case 1:
                  return ProfilePage();
                case 2:
                  return HomePage(); // You can use a different page for this if needed
                case 3:
                  return FavoritesPage(
                    favorites: [],
                    onRemoveFavorite: (p0) {},
                  ); // Or any other page
                case 4:
                  return SignupPage(); // Or another page
                default:
                  return HomePage(); // Default page
              }
            })
          : (() {
              switch (page) {
                case 0:
                  return HomePage();
                case 1:
                  return ProfilePage();
                case 2:
                  return HomePage(); // You can use a different page for this if needed
                case 3:
                  return LoginPage(); // Or any other page
                case 4:
                  return SignupPage(); // Or another page
                default:
                  return HomePage(); // Default page
              }
            })(),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
