import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/dialogs/overlay_image_dialog.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'package:rates/services/auth/auth_user.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
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
    FirebaseCloudStorage cloudService = FirebaseCloudStorage();
    final AuthUser user = AuthService.firebase().currentUser!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: FutureBuilder(
        future: cloudService.getUserInfo(user.id),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            // Added SingleChildScrollView here
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        user.profileImageUrl != null
                            ? InkWell(
                                onTap: () {},
                                child: InkWell(
                                  onTap: () {},
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(user.profileImageUrl!),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => GestureDetector(
                                      onDoubleTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5, sigmaY: 5),
                                        child: const OverlayImageDialog(),
                                      ),
                                    ),
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(
                                    '/Users/braashaban/offline_programming/Rates/user_app/assets/images/profile_images/default_profile_image_1.png',
                                  ),
                                ),
                              ),
                        const SizedBox(
                            width: 10), // Space between image and text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  user.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                  ), // Added edit icon to the username
                                )
                              ],
                            ),
                            Text(
                              "${user.numberOfRatings} Total Ratings",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Colors.black,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Your Account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCustomTile(
                    icon: SvgPicture.asset(
                      'assets/icons/profile.svg',
                      height: 25,
                      width: 25,
                    ),
                    title: "Personal Information",
                    subtitle: user.email,
                    onTap: () {
                      _showPopup(context, "Personal Information", [
                        Text("Name: ${user.userName}"),
                        Text("Email: ${user.email}"),
                      ]);
                    },
                  ),
                  _buildCustomTile(
                    icon: SvgPicture.asset('assets/icons/rewards.svg',
                        height: 25, width: 25),
                    title: "Rewards and Vouchers",
                  ),
                  _buildCustomTile(
                    icon: SvgPicture.asset('assets/icons/rating.svg',
                        height: 25, width: 25),
                    title: "Rating",
                  ),
                  _buildCustomTile(
                    icon: SvgPicture.asset('assets/icons/language.svg',
                        height: 25, width: 25),
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
                        height: 25, width: 25),
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
                        height: 25, width: 25),
                    title: "Help",
                  ),
                  _buildCustomTile(
                    icon: SvgPicture.asset('assets/icons/reset_password.svg',
                        height: 25, width: 25),
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
                        minimumSize: const Size(125, 35),
                      ),
                      onPressed: () async {
                        await AuthService.firebase().logOut();
                        Get.offAllNamed(loginRoute);
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
          );
        },
      ),
    );
  }

  Widget _buildCustomTile({
    required Widget icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
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
              height: 30,
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
