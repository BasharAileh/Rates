import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/widgets.dart';

class SvgTopToBottomFade extends StatefulWidget {
  @override
  _SvgTopToBottomFadeState createState() => _SvgTopToBottomFadeState();
}

class _SvgTopToBottomFadeState extends State<SvgTopToBottomFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _positionAnimation = Tween<double>(
      begin: 0, // Start above the screen
      end: 300, // End at the bottom edge of the SVG
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AspectRatios.width * 0.07051282051,
          vertical: AspectRatios.height * 0.34004739336,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // SVG Background
                Center(
                  child: SvgPicture.asset(
                    width: AspectRatios.width * 0.33589743589,
                    height: AspectRatios.height * 0.15521327014,
                    'assets/icons/verfication_success.svg',
                  ),
                ),
                // Animated Covering Container
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Positioned(
                      top: _positionAnimation.value,
                      child: Container(
                        width: 300,
                        height: 300,
                        color: Theme.of(context)
                            .scaffoldBackgroundColor, // Mask color
                      ),
                    );
                  },
                ),
              ],
            ),
            const Text(
              'Successfully verified',
              style: TextStyle(
                color: AppColors.greenColor,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: AspectRatios.height * 0.03554502369,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(37.5),
                ),
                minimumSize: Size(
                  AspectRatios.width * 0.58717948717,
                  AspectRatios.height * 0.05450236966,
                ),
              ),
              child: const Text(
                'Home Page',
              ),
            )
          ],
        ),
      ),
    );
  }
}
