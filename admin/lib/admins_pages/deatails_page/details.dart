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
    {'icon': 'assets/icons/location.svg', 'text': 'shop location', 'link': ''},
    {
      'icon': 'assets/icons/phone.svg',
      'text': '07(contact number)',
      'link': ''
    },
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
                        child: SvgPicture.asset(
                          imagePath,
                          height: AspectRatios.height *
                              0.2014218009478672985781990521327,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, 20),
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
                                    shopName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: socialLinks.keys.map((platform) {
                                        return SizedBox(
                                          height: AspectRatios.height * 0.05,
                                          width: AspectRatios.width * 0.1,
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            icon: SvgPicture.asset(
                                                "assets/icons/$platform.svg"),
                                            onPressed: () {},
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
                                    description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
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
                        title: Text(infoRows[index]['text']!),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AspectRatios.width * 0.0276923,
                        ),
                        horizontalTitleGap: 5,
                      ),
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
                      onPressed: () {},
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
                      onPressed: () {},
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