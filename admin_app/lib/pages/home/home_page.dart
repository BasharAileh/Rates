import 'dart:io';
import 'package:admin_app/constants/app_colors.dart';
import 'package:admin_app/pages/menu/products.dart';
import 'package:flutter/material.dart';
import "package:admin_app/constants/aspect_ratio.dart";
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';


class RestaurantInformationPage extends StatefulWidget {
  const RestaurantInformationPage({
    super.key,
  });

  @override
  State<RestaurantInformationPage> createState() =>
      RestaurantInformationPageState();
}

class RestaurantInformationPageState extends State<RestaurantInformationPage> {
  int openingHour = 9;
  int closingHour = 21;
  List<String> deliveryPlatforms = [
    'Offerat',
    'Careem food',
    'Mythings',
    'Zomato'
  ];
  List<String> selectedPlatforms = [];
  final ImagePicker _imagePicker = ImagePicker();
  String imagePath = "assets/images/yallow_logo.svg";
  String shopName = "Shop Name";
  String description = "Yemeni food";
  final Map<String, String> socialLinks = {
    'facebook': '',
    'whatsapp': '',
    'instagram': '',
  };
  List<Map<String, String?>> infoRows = [
    {'icon': 'assets/icons/location.svg', 'text': 'shop location', 'link': ''},
    {'icon': 'assets/icons/phone.svg', 'text': '07(contact number)', 'link': ''},
    {
      'icon': 'assets/icons/watch.svg',
      'text': 'Opening Hours:\n 9:00  - 1:00 '
    },
    {'icon': 'assets/icons/delivery.svg', 'text': 'Delivery Apps: '},
  ];
  final String rank = "#1st Place";
  String reviews = "300";
  double rating = 3.5;
  bool isExpanded = false;

void _pickImage() async {
  final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final mimeType = lookupMimeType(pickedFile.path);
    if (mimeType != null && mimeType.startsWith('image/')) {
      setState(() {
        imagePath = pickedFile.path;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image file'))
      );
    }
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
  TextEditingController controller = TextEditingController(text: initialValue);
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Center(child: Text("Edit Contact Number")),
      content: SizedBox(
        width: AspectRatios.width * 0.46,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone, // Restrict to numeric input
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Allow only digits
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
            infoRows[1]['text'] = value;  // Update the phone number in the infoRows
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              infoRows[1]['text'] = controller.text; // Update the infoRows with the new value
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
    if (infoRows[index]['text']!.startsWith("Opening Hours")) {
      _editHours();
    } else if (infoRows[index]['text']!.startsWith("Delivery Apps")) {
      _editDeliveryPlatforms();
    }else if(infoRows[index]['text']!.startsWith("07")){
      _editPhoneNumber(infoRows[index]['text'] ?? "");
    }
     else {
      TextEditingController controller =
          TextEditingController(text: infoRows[index]['text']);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:const Center(child:  Text("Edit Information")),
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
    int tempOpeningHour = openingHour;
    int tempClosingHour = closingHour;

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
                  const Text("Opening Hour: "),
                  DropdownButton<int>(
                    value: tempOpeningHour,
                    items: List.generate(24, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text("$index:00"),
                      );
                    }),
                    onChanged: (value) {
                      setDialogState(() {
                        tempOpeningHour = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Closing Hour: "),
                  DropdownButton<int>(
                    value: tempClosingHour,
                    items: List.generate(24, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text("$index:00"),
                      );
                    }),
                    onChanged: (value) {
                      setDialogState(() {
                        tempClosingHour = value!;
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
                      "Opening Hours:\n $openingHour:00 - $closingHour:00";
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
                  infoRows[3]['text'] =
                      "Delivery Apps: ${selectedPlatforms.join(", ")}";
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
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AspectRatios.height * 0.2014218009478672985781990521327,
                child: Stack(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: imagePath.startsWith('assets/')
                            ? SvgPicture.asset(
                                imagePath,
                                height: AspectRatios.height *
                                    0.2014218009478672985781990521327,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(imagePath),
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
                            '$rating Stars | $reviews + Reviews',
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
              Padding(
                padding: EdgeInsets.only(
                  left: AspectRatios.width * 0.05769230,
                  right: AspectRatios.width * 0.0576923,
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
                              child: SizedBox(
                                width: AspectRatios.width * 0.46,
                                child: TextFormField(
                                  initialValue: shopName,
                                  cursorColor:
                                       AppColors.primaryColor,
                                  decoration: const InputDecoration(
                                    labelText: "Shop Name",
                                    floatingLabelStyle: TextStyle(
                                      color: AppColors.primaryColor,
                                    ),
                                    enabledBorder: UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              AppColors.primaryColor,
                                          width:
                                              2),
                                    ),
                                  ),
                                  onChanged: (value) => shopName = value,
                                ),
                              ),
                            ),
                            Row(
                              children: socialLinks.keys.map((platform) {
                                return IconButton(
                                  icon: SvgPicture.asset(
                                      "assets/icons/$platform.svg"),
                                  onPressed: () => _editSocialLink(platform),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: AspectRatios.width * 0.46,
                          child: TextFormField(
                            initialValue: description,
                            decoration: const InputDecoration(
                              labelText: "Description",
                              floatingLabelStyle: TextStyle(
                                color: AppColors.primaryColor,
                              ),
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 2),
                              ),
                            ),
                            onChanged: (value) => description = value,
                          ),
                        ),
                         SizedBox(height: AspectRatios.height*0.02),
                        const Text(
                          'Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          children: List.generate(
                            infoRows.length,
                            (index) => ListTile(
                              leading: SvgPicture.asset(
                                infoRows[index]['icon']!,
                                width: AspectRatios.width * 0.06153846153,
                                height: AspectRatios.height * 0.02843601895,
                              ),
                              title: Text(infoRows[index]['text']!),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  size: AspectRatios.height * 0.025,
                                  color:
                                       AppColors.primaryColor,
                                ),
                                onPressed: () => _editInfoRow(index),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => ProductPage(
                          restaurantName: shopName,
                          restaurantImage: imagePath,
                          rating: rating,
                        ));
                  },
                  child: const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
