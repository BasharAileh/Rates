/* import 'dart:ui';

import 'package:flutter/material.dart';

//controllers
final TextEditingController _email = TextEditingController();
final TextEditingController _password1 = TextEditingController();
final TextEditingController _password2 = TextEditingController();
String _passwordError = '';

bool _isTermsChecked = false;
bool _isNewsletterChecked = false;

Future<Map?> registertest(BuildContext context) async {
  final Map? register = await showDialog<Map>(
    
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: AssetImage('assets/images/Horizontal_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.08, // Responsive font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: constraints.maxHeight *
                                  0.02), // Responsive spacing
                          _buildTextField('First Name', false),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          _buildTextField('Email', false, _email),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          _buildTextField('Password', true, _password1),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          _buildTextField(
                              'Confirm Password', true, _password2, true),
                          if (_passwordError.isNotEmpty)
                            Text(
                              _passwordError,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          _buildCheckboxRow(
                              'I agree to the terms and conditions',
                              _isTermsChecked,
                              (value) {}),
                          _buildCheckboxRow(
                              'I would like to receive the newsletter',
                              _isNewsletterChecked,
                              (value) {}),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          Center(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => {
                                    if (_password1.text != _password2.text)
                                      {
                                        _passwordError =
                                            'Passwords do not match',
                                      }
                                    else
                                      {
                                        Navigator.of(context).pop({
                                          'register': true,
                                          'email': _email,
                                          'password': _password1,
                                        },),
                                      },
                                      _email.dispose(),
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        150, 244, 143, 66), // Orange button
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 30,
                                    ),
                                  ),
                                  child: const Text('Register'),
                                ),
                                SizedBox(height: constraints.maxHeight * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Already have an account?'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                          {'register': false},
                                        );
                                      },
                                      child: const Text('Login'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
  return register;
}

// Method to build a text field
Widget _buildTextField(String labelText, bool isPassword,
    [TextEditingController? controller, bool? compare = false]) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white.withOpacity(0.75),
    ),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

// Method to build checkbox rows
Widget _buildCheckboxRow(
    String label, bool value, ValueChanged<bool?> onChanged) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
      ),
      Text(
        label,
        style: const TextStyle(
          fontSize: 12.0,
        ),
      ),
    ],
  );
}

 */
/* import 'package:flutter/material.dart';

void showSignUpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SignUpDialogContent(),
      );
    },
  );
}

class SignUpDialogContent extends StatelessWidget {
  const SignUpDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.8, // Max height to fit within the screen
      ),
      child: SingleChildScrollView(
        child: Material(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight:
                  screenHeight * 0.8, // Max height to fit within the screen
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Sign Up',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog on sign up
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 */