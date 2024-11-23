import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/dialogs/nav_bar.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AspectRatios.width * 0.07051282051,
              vertical: AspectRatios.height * 0.2962085308),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AspectRatios.height * 0.03909953,
                child: SizedBox(
                  height: AspectRatios.width * 0.42307692,
                  child: const Text(
                    'Login to Rates',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                    backgroundColor: const Color.fromARGB(255, 243, 198, 35),
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
                    child: Text('Login'),
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
                      onTap: () {},
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
                    backgroundColor: Colors.orange,
                    fixedSize: Size(
                        AspectRatios.width, AspectRatios.height * 0.05450237),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(37.5),
                    ),
                  ),
                  onPressed: () {
                    /* devtools.log('${constraints.maxWidth}'); */
                  },
                  child: const SizedBox(
                    child: Text('Login with Google'),
                  ),
                ),
              ),
              const SizedBox(
                  /*   height: constraints.maxHeight * 0.0575, */
                  ),
              // SvgPicture.asset(
              //   'assets/logos/yallow_logo.svg',
              //   width: 40,
              //   height: 40,
              // ),
              IconButton(
                  onPressed: () {
                    print('message');
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/food_icon.svg',
                    width: 40,
                    height: 40,
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
