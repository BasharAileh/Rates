import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/Pages/home/home_page.dart';
import 'package:rates/Pages/other/favorites_page.dart';
import 'package:rates/Pages/other/profile_page.dart';
import 'package:rates/Pages/registration/login_page.dart';
import 'package:rates/Pages/registration/signup_page.dart';
import 'package:rates/dialogs/nav_bar.dart';
import 'package:rates/services/cloud/temp_page.dart';

int? page;

class PagesWithNavBar extends StatefulWidget {
  const PagesWithNavBar({super.key, int? page});

  @override
  State<PagesWithNavBar> createState() => _PagesWithNavBarState();
}

class _PagesWithNavBarState extends State<PagesWithNavBar> {
  @override
  void dispose() {
    super.dispose();
    bottomNavController.changePage(2);
  }

  final BottomNavController bottomNavController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page == null
          ? Obx(() {
              // Dynamically load the page based on the selected index
              switch (bottomNavController.currentIndex.value) {
                case 0:
                  return const HomePage();
                case 1:
                  return const ProfilePage();
                case 2:
                  return const HomePage(); // You can use a different page for this if needed
                case 3:
                  return FavoritesPage(
                    favorites: const [],
                    onRemoveFavorite: (_) {},
                  ); // Or any other page
                case 4:
                  return const RatingsPage(); // Or another page
                default:
                  return const HomePage(); // Default page
              }
            })
          : (() {
              switch (page) {
                case 0:
                  page = null;
                  return const HomePage();
                case 1:
                  page = null;
                  return const ProfilePage();
                case 2:
                  page = null;
                  return const HomePage(); // You can use a different page for this if needed
                case 3:
                  page = null;
                  return const LoginPage(); // Or any other page
                case 4:
                  page = null;
                  return const SignupPage(); // Or another page
                default:
                  page = null;
                  return const HomePage(); // Default page
              }
            })(),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
