import 'dart:io';
import 'package:admin/constants/app_colors.dart';
import 'package:admin/init_page.dart';
import 'package:admin/services/auth/auth_service.dart';
import 'package:admin/services/cloud/cloud_instances.dart';
import 'package:admin/services/cloud/cloud_service.dart';
import 'package:flutter/material.dart';
import "package:admin/constants/aspect_ratio.dart";
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class RestaurantInformationPage extends StatefulWidget {
  const RestaurantInformationPage({super.key});

  @override
  State<RestaurantInformationPage> createState() =>
      RestaurantInformationPageState();
}

class RestaurantInformationPageState extends State<RestaurantInformationPage> {
  int? openingHour;
  int? closingHour;
  bool modified = false;
  List<String> deliveryPlatforms = ["Careem", "Talabat", "MyThings"];
  List<String> selectedPlatforms = [];
  final ImagePicker _imagePicker = ImagePicker();
  String? imagePath;
  String? shopName;
  String? description;
  XFile? imageFile;
  final Map<String, String> socialLinks = {
    'facebook': '',
    'whatsapp': '',
    'instagram': '',
  };
  List<Map<String, String?>> infoRows = [
    {'icon': 'assets/icons/location.svg', 'text': '', 'link': ''},
    {'icon': 'assets/icons/phone.svg', 'text': '', 'link': ''},
    {'icon': 'assets/icons/watch.svg', 'text': '', 'link': ''},
    {'icon': 'assets/icons/delivery.svg', 'text': '', 'link': ''},
  ];
  String? rank;
  String? reviews;
  double? rating;
  bool isExpanded = false;
  Shop? shop;

  void _editTextDialog(
      String title, String initialValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(title)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter text",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final mimeType = lookupMimeType(pickedFile.path);
      if (mimeType != null && mimeType.startsWith('image/')) {
        setState(() {
          imageFile = pickedFile;
          modified = true;
        });
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an image file')));
        return false;
      }
    } else {
      return false;
    }
  }

  void _editSocialLink(String platform) {
    TextEditingController controller =
        TextEditingController(text: socialLinks[platform]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text("Edit $platform Link")),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
              hintText: "Enter URL",
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: AppColors.primaryColor,
              ))),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                socialLinks[platform] = controller.text;
                modified = true;
              });
              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editPhoneNumber(String initialValue) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text("Edit Contact Number")),
        content: SizedBox(
          width: AspectRatios.width * 0.46,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              labelText: "Contact Number",
              floatingLabelStyle: TextStyle(
                color: AppColors.primaryColor,
              ),
              enabledBorder: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              ),
            ),
            onChanged: (value) {
              infoRows[1]['text'] = value;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                infoRows[1]['text'] = controller.text;
                modified = true;
              });
              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editInfoRow(int index) {
    if (infoRows[index]['icon'] == 'assets/icons/watch.svg') {
      _editHours();
    } else if (infoRows[index]['icon'] == 'assets/icons/delivery.svg') {
      _editDeliveryPlatforms();
    } else if (infoRows[index]['icon'] == 'assets/icons/phone.svg') {
      _editPhoneNumber(infoRows[index]['text'] ?? "");
    } else {
      TextEditingController controller =
          TextEditingController(text: infoRows[index]['text']);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Center(child: Text("Edit Information")),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
                hintText: "Enter Information",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: AppColors.primaryColor,
                ))),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  infoRows[index]['text'] = controller.text;
                  modified = true;
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _editHours() {
    int? tempOpeningHour = openingHour;
    int? tempClosingHour = closingHour;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Center(child: Text("Edit Opening and Closing Hours")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text("Opening Hour: ", style: TextStyle(fontSize: 15)),
                  DropdownButton<int>(
                    value: tempOpeningHour,
                    hint: const Text(
                      "Select Opening Hour",
                      style: TextStyle(fontSize: 14),
                    ),
                    items: List.generate(24, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text("$index:00"),
                      );
                    }),
                    onChanged: (value) {
                      setDialogState(() {
                        tempOpeningHour = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Closing Hour: ",
                    style: TextStyle(fontSize: 15),
                  ),
                  DropdownButton<int>(
                    value: tempClosingHour,
                    hint: const Text(
                      "Select Closing Hour",
                      style: TextStyle(fontSize: 14),
                    ),
                    items: List.generate(24, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text("$index:00"),
                      );
                    }),
                    onChanged: (value) {
                      setDialogState(() {
                        tempClosingHour = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  openingHour = tempOpeningHour;
                  closingHour = tempClosingHour;
                  infoRows[2]['text'] =
                      "${openingHour ?? '--'}:00 - ${closingHour ?? '--'}:00";
                  modified = true;
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editDeliveryPlatforms() {
    List<String> tempSelectedPlatforms = List.from(selectedPlatforms);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Center(child: Text("Select Delivery Platforms")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: deliveryPlatforms.map((platform) {
              return CheckboxListTile(
                activeColor: AppColors.primaryColor,
                value: tempSelectedPlatforms.contains(platform),
                title: Text(platform),
                onChanged: (isChecked) {
                  setDialogState(() {
                    if (isChecked!) {
                      tempSelectedPlatforms.add(platform);
                    } else {
                      tempSelectedPlatforms.remove(platform);
                    }
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedPlatforms = tempSelectedPlatforms;
                  infoRows[3]['text'] = selectedPlatforms.join(", ");
                  modified = true;
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CloudService cloudService = CloudService();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Restaurant Information",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () async {
            await AuthService.firebase().logOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => InitPage()),
              (route) => false,
            );
          },
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(-1.0, 1.0),
            child: Icon(Icons.logout),
          ),
        ),
        actions: [
          modified
              ? IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    if (modified) {
                      await cloudService.uploadShopImage(
                          File(imageFile!.path), shop!, true);
                      modified = false;
                    }
                  },
                )
              : SizedBox.shrink(),
        ],
      ),
      body: FutureBuilder(
        future: cloudService
            .getShopInfoByOwnerID(AuthService.firebase().currentUser?.id ?? ''),
        builder: (context, snapshot) {
          bool uploaded = false;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          }
          if (snapshot.hasData) {
            shop = snapshot.data as Shop;
            shopName = shop?.shopName;
            description = shop?.description;
            imagePath = shop?.imagePath;
            infoRows[0]['text'] = shop?.shopLocation;
            infoRows[1]['text'] = shop?.contactInfo['phone_number'];
            infoRows[2]['text'] = shop?.availableHours;
            infoRows[3]['text'] = shop?.deliveryApps.keys.join(", ");
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:
                      AspectRatios.height * 0.2014218009478672985781990521327,
                  child: Stack(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            uploaded = await _pickImage();
                          },
                          child: uploaded == false
                              ? (imagePath != null
                                  ? Image.network(
                                      imagePath!,
                                      height: AspectRatios.height *
                                          0.2014218009478672985781990521327,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    )
                                  : const Icon(Icons.add_a_photo,
                                      size: 50, color: Colors.grey))
                              : Image.file(
                                  File(imagePath!),
                                  height: AspectRatios.height *
                                      0.2014218009478672985781990521327,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.insert_photo,
                            color: Colors.grey,
                          ),
                          onPressed: _pickImage,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, 20),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              '${rating ?? '--'} Stars | ${reviews ?? '--'} + Reviews',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Details Section
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: AspectRatios.width * 0.05769230,
                        right: AspectRatios.width * 0.0276923,
                        top: AspectRatios.height * 0.03332938,
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      shopName ?? "Enter Shop Name",
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            size: AspectRatios.height * 0.025,
                                            color: AppColors.primaryColor),
                                        onPressed: () {
                                          _editTextDialog(
                                              "Edit Shop Name", shopName ?? "",
                                              (newValue) {
                                            setState(() {
                                              shopName = newValue;
                                              modified = true;
                                            });
                                          });
                                        },
                                      ),
                                      Row(
                                        children:
                                            socialLinks.keys.map((platform) {
                                          return SizedBox(
                                            height: AspectRatios.height * 0.05,
                                            width: AspectRatios.width * 0.1,
                                            child: IconButton(
                                              padding: const EdgeInsets.all(0),
                                              icon: SvgPicture.asset(
                                                  "assets/icons/$platform.svg"),
                                              onPressed: () =>
                                                  _editSocialLink(platform),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      description ?? "Add a description",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        size: AspectRatios.height * 0.025,
                                        color: AppColors.primaryColor),
                                    onPressed: () {
                                      _editTextDialog(
                                          "Edit Description", description ?? "",
                                          (newValue) {
                                        setState(() {
                                          description = newValue;
                                          modified = true;
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: AspectRatios.height * 0.02),
                              const Text(
                                'Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: List.generate(
                        infoRows.length,
                        (index) => ListTile(
                          leading: SvgPicture.asset(
                            infoRows[index]['icon']!,
                            width: AspectRatios.width * 0.06853846153,
                            height: AspectRatios.height * 0.02893601895,
                          ),
                          title: Text(infoRows[index]['text']!.isNotEmpty
                              ? infoRows[index]['text']!
                              : "Tap to edit"),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: AspectRatios.height * 0.025,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: () => _editInfoRow(index),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AspectRatios.width * 0.0276923,
                          ),
                          horizontalTitleGap: 5,
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/products/',
                          arguments: shop);
                    },
                    child: const Text(
                      'Edit Menu',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
