import 'package:admin/init_page.dart';
import 'package:admin/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import "package:admin/constants/aspect_ratio.dart";
import 'package:flutter_svg/svg.dart';
import 'package:admin/constants/app_colors.dart';

class CheckRes extends StatefulWidget {
  const CheckRes({
    super.key,
  });
  @override
  State<CheckRes> createState() => CheckResState();
}

class CheckResState extends State<CheckRes> {
  int openingHour = 9;
  int closingHour = 21;
  List<String> deliveryPlatforms = [
    'Offerat',
    'Careem food',
    'Mythings',
    'Zomato'
  ];
  List<String> selectedPlatforms = [];
  String imagePath = "assets/images/yallow_logo.svg";
  String shopName = "Shop Name";
  String description = "Yemeni food";
  final Map<String, String> socialLinks = {
    'facebook': '',
    'whatsapp': '',
    'instagram': '',
  };
  List<Map<String, String?>> infoRows = [
    {'icon': 'assets/icons/phone.svg', 'text': 'Phone Number', 'link': ''},
    {'icon': 'assets/icons/location.svg', 'text': 'Shop location', 'link': ''},
    {'icon': 'assets/icons/email.svg', 'text': 'Email', 'link': ''},
    {'icon': 'assets/icons/watch.svg', 'text': 'Available Hours'},
    {'icon': 'assets/icons/delivery.svg', 'text': 'Available On'},
  ];
  final String rank = "#1st Place";
  String reviews = "300";
  double rating = 3.5;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final shopData = ModalRoute.of(context)!.settings.arguments as Map;
    shopData.remove('Password');
    shopData.remove('Confirm Password');
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
                width: double.infinity,
                child: Image.network(
                  shopData['image_path']!,
                  width: double.infinity,
                  height: AspectRatios.height * 0.2,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: AspectRatios.height * 0.02,
                      ),
                      child: Text(
                        shopData['Shop Name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AspectRatios.height * 0.02),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AspectRatios.width * 0.05769230,
                    ),
                    child: const Text(
                      'Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(
                      infoRows.length,
                      (index) {
                        if (shopData[infoRows[index]['text']] is List) {
                          return ListTile(
                            leading: SvgPicture.asset(
                              infoRows[index]['icon']!,
                              width: AspectRatios.width * 0.06853846153,
                              height: AspectRatios.height * 0.02893601895,
                            ),
                            title: Row(
                              children: List.generate(
                                shopData[infoRows[index]['text']]!.length,
                                (i) => Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Text(
                                      shopData[infoRows[index]['text']]![i]),
                                ),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AspectRatios.width * 0.0276923,
                            ),
                            horizontalTitleGap: 5,
                          );
                        } else {
                          return ListTile(
                            leading: SvgPicture.asset(
                              infoRows[index]['icon']!,
                              width: AspectRatios.width * 0.06853846153,
                              height: AspectRatios.height * 0.02893601895,
                            ),
                            title:
                                Text(shopData[infoRows[index]['text']] ?? ''),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AspectRatios.width * 0.0276923,
                            ),
                            horizontalTitleGap: 5,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: AspectRatios.height * 0.02,
                  ),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        /* await cloudService.deletePendingRestaurant(
                            shopData['documentID']); */
                      },
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Accept Restaurant'),
                              content: const Text(
                                  'Are you sure you want to accept this restaurant?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  onPressed: () {
                                    /*  AuthService.firebase().createUser(
                                      email: shopData['email'],
                                      password: shopData['Password'],
                                      userName: shopData['Shop Name'],
                                    ); */
                                    try {
                                      final editedShopData =
                                          shopData as Map<String, dynamic>;
                                      editedShopData['phone_number'] = {
                                        'phone_number': shopData['Phone Number']
                                      };
                                      editedShopData['email'] = {
                                        'phone_number': shopData['Email']
                                      };
                                      print(editedShopData);

                                      /* cloudService.uploadShopData(
                                        shopData as Map<String, dynamic>,
                                        shopData['Shop Category'].toString(),
                                      ); */
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
