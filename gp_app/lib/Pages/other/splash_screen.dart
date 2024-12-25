import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rates/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _lettersController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _positionAnimations;

  late AnimationController _sentenceController;
  late Animation<double> _sentenceFadeAnimations;
  late Animation<Offset> _sentencePositionAnimations;

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
    Alignment.topCenter + const Alignment(0.27, 0.92),
    Alignment.topCenter + const Alignment(0.19, 0.9),
    Alignment.topCenter + const Alignment(0.0, 0.88),
    Alignment.topCenter + const Alignment(0.05, 0.85),
    Alignment.topCenter + const Alignment(-0.16, 0.845),
    Alignment.topCenter + const Alignment(0.1, 0.895),
    Alignment.topCenter + const Alignment(0.2, 0.87),
  ];

  @override
  void initState() {
    super.initState();

    // Letters Animation
    _lettersController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
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

    /// Sentence Animation
    _sentenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _sentenceFadeAnimations = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sentenceController,
        curve: Curves.easeInOutCubic,
      ),
    );
    _sentencePositionAnimations = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -1.0),
    ).animate(
      CurvedAnimation(
        parent: _sentenceController,
        curve: Curves.easeInOut,
      ),
    );

    // Lower Star Animation
    _lowerStarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
      duration: const Duration(milliseconds: 1500),
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
          const Duration(milliseconds: 200),
          () {
            _lowerStarController.forward();
            for (int i = 0; i < _popupControllers.length; i++) {
              Future.delayed(
                Duration(milliseconds: i * 50),
                () {
                  _popupControllers[i].forward().then(
                    (_) {
                      _sentenceController.forward();
                    },
                  );
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
    _sentenceController.dispose();
    for (var controller in _popupControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          // Upper Star
          Align(
            alignment: Alignment.topCenter + const Alignment(0.05, 0.88),
            child: SvgPicture.asset(
              width: 120,
              'assets/logos/stars/upper_star.svg',
            ),
          ),
          Align(
            alignment: Alignment.topCenter + const Alignment(0.05, 0.88),
            child: AnimatedBuilder(
              animation: _upperStarController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _upperStarFadeAnimation,
                  child: SlideTransition(
                    position: _upperStarSlideAnimation,
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration:
                          const BoxDecoration(color: AppColors.primaryColor),
                    ),
                  ),
                );
              },
            ),
          ),

          // Lower Star
          Align(
            alignment: Alignment.centerLeft + const Alignment(0.9, -0.09),
            child: SvgPicture.asset(
              width: 100,
              '/Users/braashaban/offline_programming/Rates/gp_app/assets/logos/stars/lower_star.svg',
            ),
          ),
          Align(
            alignment: Alignment.centerLeft + const Alignment(0.9, -0.09),
            child: AnimatedBuilder(
              animation: _lowerStarController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _lowerStarFadeAnimation,
                  child: SlideTransition(
                    position: _lowerStarSlideAnimation,
                    child: Container(
                      width: 100,
                      height: 20,
                      decoration:
                          const BoxDecoration(color: AppColors.primaryColor),
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
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_lettersPath.length, (index) {
                return AnimatedBuilder(
                  animation: _lettersController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimations[index].value,
                      child: SlideTransition(
                        position: _positionAnimations[index],
                        child: SvgPicture.asset(
                          _lettersPath[index],
                          width: 50,
                          height: 50,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          AnimatedBuilder(
            animation: _sentencePositionAnimations,
            builder: (context, child) {
              return FadeTransition(
                opacity: _sentenceFadeAnimations,
                child: Align(
                  alignment:
                      Alignment.bottomCenter + const Alignment(0.0, -0.83),
                  child: Text(
                    'Your Guide to the Best of \nEverything',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
