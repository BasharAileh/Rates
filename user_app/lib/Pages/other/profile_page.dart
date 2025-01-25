import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/constants/theme_controller.dart';
import 'package:rates/dialogs/overlay_image_dialog.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'package:rates/services/auth/auth_user.dart';
import 'package:rates/services/cloud/cloud_instances.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedLanguage = "English";
  bool isEditing = false;
  late Future<FireStoreUser> _userFuture;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final ThemeController _themeController = Get.find<ThemeController>(); // Get the ThemeController instance

  @override
  void initState() {
    super.initState();
    _userFuture = FirebaseCloudStorage()
        .getUserInfo(AuthService.firebase().currentUser!.id);
  }

  void _showPopup(BuildContext context, String title, List<Widget> content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("Do you want to save the changes?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Save
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    FirebaseCloudStorage cloudService = FirebaseCloudStorage();
    final AuthUser user = AuthService.firebase().currentUser!;
    bool isDialogOpen = false;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('User data not found.'),
            );
          }

          final FireStoreUser userInfo = snapshot.data!;
          String profileImageUrl = userInfo.profileImageURL;

          if (user.isAnonymous) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: AspectRatios.height*0.1,
              color: isDarkMode ? Colors.white54 : Colors.black54,
            ),
             SizedBox(height: AspectRatios.height*0.005),
            Text(
              'Please login to view your profile.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            ElevatedButton(
                  onPressed: () async {
                    Get.offAllNamed('/login/');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 196, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  child: const Text(
                    'LogIn',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }


          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        user.profileImageUrl != null &&
                                user.profileImageUrl!.contains('http')
                            ? InkWell(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(user.profileImageUrl!),
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
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(
                                    profileImageUrl,
                                  ),
                                ),
                              ),
                         SizedBox(width: AspectRatios.height*0.015),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                isEditing
                                    ? SizedBox(
                                        width: AspectRatios.width*0.4,
                                        child: TextField(
                                          focusNode: _focusNode,
                                          controller: _controller,
                                          autofocus: true,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter your name',
                                          ),
                                          onEditingComplete: () async {
                                            _focusNode.unfocus();

                                            if (_controller.text !=
                                                    userInfo.userName &&
                                                !isDialogOpen) {
                                              isDialogOpen = true;
                                              final bool? result =
                                                  await _showConfirmationDialog();
                                              if (result == true) {
                                                await AuthService.firebase()
                                                    .updateUserName(
                                                  displayName: _controller.text,
                                                );
                                              } else if (result == false) {
                                                _controller.text =
                                                    userInfo.userName;
                                              }
                                            }

                                            setState(() {
                                              isEditing =
                                                  false; // Exit editing mode
                                            });
                                          },
                                          onSubmitted: (_) async {
                                            _focusNode
                                                .unfocus(); // Hide the keyboard

                                            if (_controller.text !=
                                                    userInfo.userName &&
                                                !isDialogOpen) {
                                              final bool? result =
                                                  await _showConfirmationDialog();

                                              if (result == true) {
                                                isDialogOpen = true;
                                                await AuthService.firebase()
                                                    .updateUserName(
                                                  displayName: _controller.text,
                                                );
                                              } else if (result == false) {
                                                _controller.text =
                                                    userInfo.userName;
                                              }
                                            }

                                            setState(() {
                                              isEditing = false;
                                            });
                                          },
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isEditing = true;
                                            _controller.text =
                                                userInfo.userName;
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              _focusNode.requestFocus();
                                            });
                                          });
                                        },
                                        child: StreamBuilder(
                                          stream: cloudService
                                              .getUserStream(user.id),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              String userName =
                                                  snapshot.data?['user_name'];
                                              _controller.text = userName;
                                              return Text(
                                                _controller.text,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              );
                                            }
                                            return const SizedBox();
                                          },
                                        ),
                                      ),
                                 SizedBox(width:AspectRatios.width*0.02),
                                IconButton(
                                  icon: Icon(
                                    isEditing ? Icons.check : Icons.edit,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  onPressed: () async {
                                    if (isEditing) {
                                      _focusNode.unfocus(); // Hide the keyboard

                                      if (_controller.text !=
                                              userInfo.userName &&
                                          !isDialogOpen) {
                                        isDialogOpen = true;
                                        final bool? result =
                                            await _showConfirmationDialog();

                                        if (result == true) {
                                          await AuthService.firebase()
                                              .updateUserName(
                                            displayName: _controller.text,
                                          );
                                        } else if (result == false) {
                                          _controller.text = userInfo.userName;
                                        }
                                      }

                                      setState(() {
                                        isEditing = false;
                                      });
                                    } else {
                                      setState(() {
                                        isEditing = true;
                                        _controller.text = userInfo.userName;
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          _focusNode.requestFocus();
                                        });
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: AspectRatios.height*0.02),
                  Divider(
                    color: isDarkMode ? Colors.white : Colors.black,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                   SizedBox(height: AspectRatios.height*0.02),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Your Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                   SizedBox(height: AspectRatios.height*0.02),
                  _buildCustomTile(
                    icon: SvgPicture.asset(
                      'assets/icons/profile.svg',
                      height: AspectRatios.height*0.03,
                      width: AspectRatios.width*0.02,
                      colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                    ),
                    title: "Personal Information",
                    subtitle: user.email,
                    onTap: () {
                      _showPopup(context, "Personal Information", [
                        Text(
                          "Name: ${user.userName}",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          "Email: ${user.email}",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ]);
                    },
                  ),
                  _buildCustomTile(
                    icon: SvgPicture.asset(
                      'assets/icons/rewards.svg',
                       height: AspectRatios.height*0.03,
                      width: AspectRatios.width*0.03,
                       colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                    ),
                    title: "Rewards and Vouchers",
                  ),
                  _buildCustomTile(
                    icon: SvgPicture.asset(
                      'assets/icons/rating.svg',
                       height: AspectRatios.height*0.03,
                      width: AspectRatios.width*0.03,
                       colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                    ),
                    title: "Rating",
                  ),
                  _buildCustomTile(
                    icon: SvgPicture.asset(
                      'assets/icons/language.svg',
                       height: AspectRatios.height*0.03,
                      width: AspectRatios.width*0.03,
                       colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                    ),
                    title: "Language",
                    subtitle: selectedLanguage,
                    onTap: () {
                      _showPopup(context, "Language", [
                        RadioListTile<String>(
                          title: Text(
                            "Arabic",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          value: "Arabic",
                          activeColor: isDarkMode ? Colors.white : Colors.black,
                          groupValue: selectedLanguage,
                          onChanged: (value) {
                            setState(() => selectedLanguage = value!);
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<String>(
                          title: Text(
                            "English",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          value: "English",
                          activeColor: isDarkMode ? Colors.white : Colors.black,
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
                    icon: SvgPicture.asset(
                      'assets/icons/theme.svg',
                     height: AspectRatios.height*0.03,
                      width: AspectRatios.width*0.03,
                       colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                    ),
                    title: "Theme",
                    subtitle: _themeController.themeMode == ThemeMode.light
                        ? "Light"
                        : _themeController.themeMode == ThemeMode.dark
                            ? "Dark"
                            : "System", // Show current theme
                    onTap: () {
                      _showPopup(context, "Theme", [
                        RadioListTile<String>(
                          title: Text(
                            "Light",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          value: "Light",
                          activeColor: isDarkMode ? Colors.white : Colors.black,
                          groupValue: _themeController.themeMode == ThemeMode.light
                              ? "Light"
                              : _themeController.themeMode == ThemeMode.dark
                                  ? "Dark"
                                  : "System",
                          onChanged: (value) {
                            _themeController.toggleTheme("Light"); // Switch to light theme
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<String>(
                          title: Text(
                            "Dark",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          value: "Dark",
                          activeColor: isDarkMode ? Colors.white : Colors.black,
                          groupValue: _themeController.themeMode == ThemeMode.light
                              ? "Light"
                              : _themeController.themeMode == ThemeMode.dark
                                  ? "Dark"
                                  : "System",
                          onChanged: (value) {
                            _themeController.toggleTheme("Dark"); // Switch to dark theme
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<String>(
                          title: Text(
                            "System",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          value: "System",
                          activeColor: isDarkMode ? Colors.white : Colors.black,
                          groupValue: _themeController.themeMode == ThemeMode.light
                              ? "Light"
                              : _themeController.themeMode == ThemeMode.dark
                                  ? "Dark"
                                  : "System",
                          onChanged: (value) {
                            _themeController.toggleTheme("System"); // Switch to system theme
                            Navigator.of(context).pop();
                          },
                        ),
                      ]);
                    },
                  ),
                  _buildCustomTile(
                    icon: SvgPicture.asset(
                      'assets/icons/help.svg',
                      height: AspectRatios.height*0.03,
                      width: AspectRatios.width*0.03,
                      colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                    ),
                    title: "Help",
                  ),
                  _buildCustomTile(
                    icon: SvgPicture.asset(
                      'assets/icons/reset_password.svg',
                     height: AspectRatios.height*0.03,
                      width: AspectRatios.width*0.03,
                       colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                    ),
                    title: "Reset Password",
                  ),
                   SizedBox(height: AspectRatios.height*0.015),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            icon,
             SizedBox(width:AspectRatios.width*0.05),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/arrow.svg',
             height: AspectRatios.height*0.035,
                      width: AspectRatios.width*0.03,
              colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
            ),
          ],
        ),
      ),
    );
  }
}