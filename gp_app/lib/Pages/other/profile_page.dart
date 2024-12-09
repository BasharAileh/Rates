import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rates/constants/aspect_ratio.dart';

import '../../dialogs/nav_bar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedLanguage = "English";
  String selectedTheme = "Light";

  void _showPopup(BuildContext context, String title, List<Widget> content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
            selectionColor: Colors.black,
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView here
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30, // Reduced avatar size
                      backgroundImage: AssetImage('assets/images/Bara.jpeg'),
                    ),
                    SizedBox(width: 10), // Space between image and text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hamza Shakhatreh",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "132 total ratings",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: const Divider(thickness: 2, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: const Text(
                  "Your Account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const SizedBox(height: 8),
              _buildCustomTile(
                icon: SvgPicture.asset('assets/icons/profile.svg',
                    height: 20, width: 20),
                title: "Personal Information",
                subtitle: "hamzashakhatreh@gmail.com",
                onTap: () {
                  _showPopup(context, "Personal Information", [
                    const Text("Name: Hamza Shakhatreh"),
                    const Text("Email: hamzashakhatreh@gmail.com"),
                    const Text("Date of Birth: 16/8/2003"),
                  ]);
                },
              ),
              _buildCustomTile(
                icon: SvgPicture.asset('assets/icons/rewards.svg',
                    height: 20, width: 20),
                title: "Rewards and Vouchers",
              ),
              _buildCustomTile(
                icon: SvgPicture.asset('assets/icons/rating.svg',
                    height: 20, width: 20),
                title: "Rating",
              ),
              _buildCustomTile(
                icon: SvgPicture.asset('assets/icons/language.svg',
                    height: 20, width: 20),
                title: "Language",
                subtitle: selectedLanguage,
                onTap: () {
                  _showPopup(context, "Language", [
                    RadioListTile<String>( 
                      title: const Text("Arabic"),
                      value: "Arabic",
                      activeColor: Colors.black,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() => selectedLanguage = value!);
                        Navigator.of(context).pop();
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("English"),
                      value: "English",
                      activeColor: Colors.black,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() => selectedLanguage = value!);
                        Navigator.of(context).pop();
                      },
                    ),
                  ]);
                },
              ),
              _buildCustomTile(
                icon: SvgPicture.asset('assets/icons/theme.svg',
                    height: 20, width: 20),
                title: "Theme",
                subtitle: selectedTheme,
                onTap: () {
                  _showPopup(context, "Theme", [
                    RadioListTile<String>( 
                      title: const Text("Light"),
                      value: "Light",
                      activeColor: Colors.black,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        setState(() => selectedTheme = value!);
                        Navigator.of(context).pop();
                      },
                    ),
                    RadioListTile<String>( 
                      title: const Text("Dark"),
                      value: "Dark",
                      activeColor: Colors.black,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        setState(() => selectedTheme = value!);
                        Navigator.of(context).pop();
                      },
                    ),
                  ]);
                },
              ),
              _buildCustomTile(
                icon: SvgPicture.asset('assets/icons/help.svg',
                    height: 20, width: 20),
                title: "Help",
              ),
              _buildCustomTile(
                icon: SvgPicture.asset('assets/icons/reset_password.svg',
                    height: 20, width: 20),
                title: "Reset Password",
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3C623),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(130, 35),
                  ),
                  onPressed: () {
                    // Logout logic here
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }

  Widget _buildCustomTile({
    required Widget icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/arrow.svg',
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
