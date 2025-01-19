import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/routes.dart';
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
  String selectedTheme = "Light";
  bool isEditing = false;
  late Future<FireStoreUser> _userFuture;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
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
    final AuthUser user = AuthService.firebase().currentUser!;
    bool isDialogOpen = false;

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

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: profileImageUrl.contains('http')
                                ? NetworkImage(profileImageUrl)
                                : AssetImage(profileImageUrl) as ImageProvider,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                isEditing
                                    ? SizedBox(
                                        width: 150,
                                        child: TextField(
                                          focusNode: _focusNode,
                                          controller: _controller,
                                          autofocus: true,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter your name',
                                          ),
                                          onEditingComplete: () async {
                                            _focusNode
                                                .unfocus(); // Hide the keyboard

                                            if (_controller.text !=
                                                    userInfo.userName &&
                                                !isDialogOpen) {
                                              isDialogOpen = true;
                                              // Text has changed, show confirmation dialog
                                              final bool? result =
                                                  await _showConfirmationDialog();

                                              if (result == true) {
                                                await AuthService.firebase()
                                                    .updateUserName(
                                                  displayName: _controller.text,
                                                )
                                                    .then((value) {
                                                  setState(() {});
                                                });
                                              } else if (result == false) {
                                                print('User pressed Cancel');
                                                // Revert local changes
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
                                                print('User pressed Save');
                                                // Update the cloud username
                                                await AuthService.firebase()
                                                    .updateUserName(
                                                  displayName: _controller.text,
                                                )
                                                    .then((value) {
                                                  setState(() {});
                                                });
                                                setState(() {});
                                              } else if (result == false) {
                                                print('User pressed Cancel');
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
                                        child: Text(
                                          userInfo.userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    isEditing ? Icons.check : Icons.edit,
                                    color: Colors.black,
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
                                          print('User pressed Save');
                                          // Update the cloud username
                                          await AuthService.firebase()
                                              .updateUserName(
                                            displayName: _controller.text,
                                          )
                                              .then((value) {
                                            setState(() {});
                                          });
                                        } else if (result == false) {
                                          print('User pressed Cancel');
                                          _controller.text = userInfo.userName;
                                        }
                                      }

                                      setState(() {
                                        isEditing = false; // Exit editing mode
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
