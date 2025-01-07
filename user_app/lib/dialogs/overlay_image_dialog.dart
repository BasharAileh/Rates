import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OverlayImageDialog extends StatefulWidget {
  const OverlayImageDialog({super.key});

  @override
  State<OverlayImageDialog> createState() => _OverlayImageDialogState();
}

List<String> profileImages = [
  '/Users/braashaban/offline_programming/Rates/user_app/assets/images/profile_images/default_profile_image_1.png',
  '/Users/braashaban/offline_programming/Rates/user_app/assets/images/profile_images/default_profile_image_2.png',
  '/Users/braashaban/offline_programming/Rates/user_app/assets/images/profile_images/default_profile_image_3.png',
  '/Users/braashaban/offline_programming/Rates/user_app/assets/images/profile_images/default_profile_image_4.png',
  '/Users/braashaban/offline_programming/Rates/user_app/assets/images/profile_images/default_profile_image_5.png',
  '/Users/braashaban/offline_programming/Rates/user_app/assets/images/profile_images/default_profile_image_6.png',
  '/Users/braashaban/offline_programming/Rates/user_app/assets/images/profile_images/default_profile_image_7.png',
  '/Users/braashaban/offline_programming/Rates/user_app/assets/images/profile_images/default_profile_image_8.png',
];

late final PageController _pageController;
bool _isInitailized = false;

class _OverlayImageDialogState extends State<OverlayImageDialog> {
  @override
  void initState() {
    super.initState();
    if (!_isInitailized) {
      _pageController = PageController(
        initialPage: 1,
        viewportFraction: 0.8,
      );
      _isInitailized = true;
    }
  }

  @override
  void dispose() {
    if (_pageController.hasClients) {
      _pageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            print('Tapped and closing dialog');
            Get.back();
          },
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: PageView.builder(
                      itemCount: profileImages.length + 1,
                      controller: _pageController,
                      onPageChanged: (index) {
                        if (mounted) {
                          _pageController.jumpToPage(index);
                        }
                      },
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: Alignment.center,
                          child: index == 0
                              ? InkWell(
                                  onTap: () {
                                    // Navigator.of(context).pushNamed(
                                    //   AppRoutes.profileImageSelection,
                                    // );
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Color.fromARGB(
                                      155,
                                      244,
                                      231,
                                      225,
                                    ),
                                    radius: 140,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: AssetImage(
                                    profileImages[index - 1],
                                  ),
                                  radius: 140,
                                ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: profileImages.length + 1,
                    effect: const SwapEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      activeDotColor: AppColors.primaryColor,
                      dotColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
