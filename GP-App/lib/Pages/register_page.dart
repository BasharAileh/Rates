import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rates/constants/decorations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? _selectedGender;
  bool _isTermsChecked = false;
  bool _isNewsletterChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.02),
                Row(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.05,
                    ),
                    const Text('Gender :'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Radio<String>(
                      value: 'M',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(
                          () {
                            _selectedGender = value;
                          },
                        );
                      },
                    ),
                    const Text('Male'),
                    const SizedBox(width: 16),
                    Radio<String>(
                      value: 'F',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
                const SizedBox(height: 16),
                Transform.translate(
                  offset: Offset(-constraints.maxWidth * 0.025, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 0.75,
                        child: Checkbox(
                          value: _isTermsChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isTermsChecked = value!;
                            });
                          },
                        ),
                      ),
                      const Text(
                        'I agree to the terms and conditions',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset(-constraints.maxWidth * 0.025,
                      -constraints.maxHeight * 0.04),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 0.75,
                        child: Checkbox(
                          value: _isNewsletterChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isNewsletterChecked = value!;
                            });
                          },
                        ),
                      ),
                      const Text(
                        'I would like to receive the newsletter',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
