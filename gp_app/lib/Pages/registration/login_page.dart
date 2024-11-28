import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';

int pageIndex = 2;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: AspectRatios.height * 0.150379146919,
          left: AspectRatios.width * 0.07051282051,
          right: AspectRatios.width * 0.07051282051,
        ),

        /* symmetric(
          vertical: AspectRatios.height * 0.19379146919,
          horizontal: AspectRatios.width * 0.07051282051,
        ), */
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                    width: 80,
                    '/Users/braashaban/offline_programming/Rates/gp_app/assets/logos/black_logo.svg'),
              ),
              SizedBox(
                height: AspectRatios.height * 0.04909953,
              ),
              Row(
                children: [
                  Text(
                    'Login to Rates',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ), /* 
                  Transform.translate(
                    offset: Offset(0, -10),
                    child: SvgPicture.asset(
                      height: AspectRatios.height * 0.04909953,
                      'assets/logos/black_logo.svg',
                    ),
                  ), */
                ],
              ),
              SizedBox(height: AspectRatios.height * 0.03554502369),
              Row(
                children: [
                  const SizedBox(
                      /* width: constraints.maxWidth * 0.02, */
                      ),
                  SizedBox(
                    height: AspectRatios.height * 0.01895734597,
                    child: const Text('Email or Phone Number'),
                  ),
                ],
              ),
              SizedBox(
                width: AspectRatios.width * 0.85897435897,
                height: AspectRatios.height * 0.05450236966,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(37.5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AspectRatios.height * 0.03554502369,
              ),
              SizedBox(
                height: AspectRatios.height * 0.01895734597,
                child: const Row(
                  children: [
                    SizedBox(
                        /*   width: constraints.maxWidth * 0.02, */
                        ),
                    Text('Password'),
                  ],
                ),
              ),
              SizedBox(
                width: AspectRatios.width * 0.85897435897,
                height: AspectRatios.height * 0.05450236966,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(37.5),
                    ),
                  ),
                ),
              ),
              const Row(
                children: [
                  SizedBox(
                      /*   width: constraints.maxWidth * 0.02, */
                      ),
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AspectRatios.height * 0.01777251,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: Size(AspectRatios.width * 0.58717948717,
                        AspectRatios.height * 0.05450236966),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(37.5),
                    ),
                  ),
                  onPressed: () {
                    /* devtools.log('${constraints.maxWidth}'); */
                  },
                  child: const SizedBox(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AspectRatios.height * 0.01421801,
              ),
              SizedBox(
                height: AspectRatios.height * 0.02251185,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                        /* width: constraints.maxWidth * 0.02, */
                        ),
                    const Text(
                      'Don\'t have an account?',
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(signupRoute);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AspectRatios.height * 0.03406398,
              ),
              const Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Text('or sign in with email'),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AspectRatios.height * 0.01421801,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0),
                      shadowColor: Colors.white.withOpacity(0),
                      fixedSize: Size(AspectRatios.width,
                          AspectRatios.height * 0.05450236966),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(37.5),
                      ),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      )),
                  onPressed: () {
                    /* devtools.log('${constraints.maxWidth}'); */
                  },
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/google.svg',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: AspectRatios.width * 0.02564102564,
                        ),
                        const Text(
                          'Continue with Google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AspectRatios.height * 0.03406398,
              ),
              Center(
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    )),
              ),
              // SvgPicture.asset(
              //   'assets/logos/yallow_logo.svg',
              //   width: 40,
              //   height: 40,
              // ),
              /*  IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/food_icon.svg',
                    width: 40,
                    height: 40,
                  )), */
            ],
          ),
        ),
      ),
    );
  }
}
