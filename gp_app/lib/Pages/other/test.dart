import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
  late AnimationController _lettersController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _positionAnimations;

  late AnimationController _lowerStarController;
  late Animation<double> _lowerStarFadeAnimation;
  late Animation<Offset> _lowerStarSlideAnimation;

  late AnimationController _upperStarController;
  late Animation<double> _upperStarFadeAnimation;
  late Animation<Offset> _upperStarSlideAnimation;

  late List<AnimationController> _popupControllers;
  late List<Animation<double>> _popupFadeAnimations;
  late List<Animation<double>> _popupScaleAnimations;

  final List<String> _lettersPath = [
    'assets/logos/letters/R.svg',
    'assets/logos/letters/A.svg',
    'assets/logos/letters/T.svg',
    'assets/logos/letters/E.svg',
    'assets/logos/letters/S.svg',
  ];

  final List<String> starPaths = List.generate(
    7,
    (index) =>
        '/Users/braashaban/offline_programming/Rates/gp_app/assets/logos/stars/small_star_${index + 1}.svg',
  );
  final List<double> starSzie = List.generate(7, (index) {
    double startSize = 1.85;
    if (index % 2 == 0 && index != 5 && index != 6) {
      startSize += startSize + startSize;
    } else if (index == 1) {
      startSize += 2 * startSize * startSize;
    } else {
      startSize += 3 * startSize * startSize;
    }
    return startSize;
  });

  // Predefined alignment positions for the stars
  final List<Alignment> starAlignments = [
    Alignment.center + const Alignment(-0.5, -0.5),
    Alignment.center + const Alignment(0.5, -0.5),
    Alignment.center + const Alignment(0.5, 0.5),
    Alignment.center + const Alignment(-0.5, 0.5),
    Alignment.center + const Alignment(-0.5, 0.0),
    Alignment.center + const Alignment(0.5, 0.0),
    Alignment.center + const Alignment(0.0, 0.5),
  ];

  @override
  void initState() {
    super.initState();

    // Letters Animation
    _lettersController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimations = [];
    _positionAnimations = [];
    for (int i = 0; i < _lettersPath.length; i++) {
      final start = i / _lettersPath.length;
      final end = (i + 1) / _lettersPath.length;
      _fadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _lettersController,
            curve: Interval(start, end, curve: Curves.easeInOut),
          ),
        ),
      );
      _positionAnimations.add(
        Tween<Offset>(
          begin: const Offset(0.5, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _lettersController,
            curve: Interval(start, end, curve: Curves.easeInOut),
          ),
        ),
      );
    }

    // Lower Star Animation
    _lowerStarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _lowerStarFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _lowerStarController,
        curve: Curves.easeInOut,
      ),
    );
    _lowerStarSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-1.5, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _lowerStarController,
        curve: Curves.easeOutCirc,
      ),
    );

    // Upper Star Animation
    _upperStarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _upperStarFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _upperStarController,
        curve: Curves.easeInOut,
      ),
    );
    _upperStarSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-1.5, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _upperStarController,
        curve: Curves.easeOutCirc,
      ),
    );

    // Popup Animations for Stars
    _popupControllers = List.generate(
      starPaths.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _popupFadeAnimations = List.generate(
      starPaths.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _popupControllers[index],
          curve: Curves.easeInOut,
        ),
      ),
    );

    _popupScaleAnimations = List.generate(
      starPaths.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _popupControllers[index],
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // Start Animations in Sequence
    _lettersController.forward().then(
      (_) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            _lowerStarController.forward();
            for (int i = 0; i < _popupControllers.length; i++) {
              Future.delayed(
                Duration(milliseconds: i * 125),
                () {
                  _popupControllers[i].forward();
                },
              );
            }
            Future.delayed(
              const Duration(milliseconds: 300),
              () {
                _upperStarController.forward();
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _lettersController.dispose();
    _lowerStarController.dispose();
    _upperStarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: AspectRatios.width * 0.4282051282,
              height: AspectRatios.height * 0.13151658767,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final width = AspectRatios.width;
                  final height = AspectRatios.height;
                  double dynamicWidthPixelSize(double pixel) {
                    return (pixel / width) * width;
                  }

                  double dynamicHeightPixelSize(double pixel) {
                    return (pixel / height) * height;
                  }

                  return Stack(
                    children: [
                      // Upper Star
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: height * 0.35043589743,
                          height: height * 0.05511848341,
                          child: SvgPicture.asset(
                            '/Users/braashaban/offline_programming/Rates/gp_app/assets/logos/stars/upper_star.svg',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: AnimatedBuilder(
                          animation: _upperStarController,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _upperStarFadeAnimation,
                              child: SlideTransition(
                                position: _upperStarSlideAnimation,
                                child: Container(
                                  width: height * 0.35043589743,
                                  height: height * 0.05511848341,
                                  decoration: const BoxDecoration(
                                      color: AppColors.primaryColor),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Lower Star
                      Align(
                        alignment:
                            Alignment.center + const Alignment(-1.1, 0.35),
                        child: SizedBox(
                          width: width * 0.29623076923,
                          height: height * 0.02388625592,
                          child: SvgPicture.asset(
                            '/Users/braashaban/offline_programming/Rates/gp_app/assets/logos/stars/lower_star.svg',
                          ),
                        ),
                      ),
                      Align(
                        alignment:
                            Alignment.center + const Alignment(-1.1, 0.35),
                        child: AnimatedBuilder(
                          animation: _lowerStarController,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _lowerStarFadeAnimation,
                              child: SlideTransition(
                                position: _lowerStarSlideAnimation,
                                child: Container(
                                  width: width * 0.29623076923,
                                  height: height * 0.02388625592,
                                  decoration: const BoxDecoration(
                                      color: AppColors.primaryColor),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      ...List.generate(7, (index) {
                        return Align(
                          alignment: starAlignments[index],
                          child: AnimatedBuilder(
                            animation: _popupControllers[index],
                            builder: (context, child) {
                              return FadeTransition(
                                opacity: _popupFadeAnimations[index],
                                child: ScaleTransition(
                                  scale: _popupScaleAnimations[index],
                                  child: SvgPicture.asset(
                                    width: starSzie[index],
                                    starPaths[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      // Letters
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
