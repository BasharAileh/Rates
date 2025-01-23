import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/services/cloud/cloud_instances.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'menu_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:developer' as devtools show log;

class RestaurantInformationPage extends StatefulWidget {
  const RestaurantInformationPage({
    super.key,
  });

  @override
  State<RestaurantInformationPage> createState() =>
      RestaurantInformationPageState();
}

class RestaurantInformationPageState extends State<RestaurantInformationPage> {
  Shop? shop;

  late final List<String> imgList = [];

  final Map<String, String> socialLinks = {
    'facebook': 'https://web.facebook.com/babalyemenrestaurants/?_rdc=1&_rdr',
    'whatsapp': 'https://www.whatsapp.com/',
    'instagram': 'https://www.instagram.com',
  };
  Map icons = {
    'rank': {'icon': 'assets/icons/podium_icon.svg', 'value': ""},
    'shopLocation': {'icon': 'assets/icons/location.svg', 'value': ""},
    'contactInfo': {'icon': 'assets/icons/phone.svg', 'value': ""},
    'available hours': {'icon': 'assets/icons/watch.svg', 'value': ""},
    'delivery': {'icon': 'assets/icons/delivery.svg', 'value': ""},
  };
  final String rank = "#1st Place";
  String reviews = "300";

  Future<void> _launchUrl(String input) async {
    final uri = Uri.tryParse(input);
    if (uri != null) {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(
          uri,
          mode: input.startsWith('tel:')
              ? LaunchMode.platformDefault
              : LaunchMode.externalApplication,
        );
      } else {
        print('Cannot launch $input');
        throw 'Could not launch $input';
      }
    } else {
      print('Invalid input: $input');
      throw 'Invalid input: $input';
    }
  }

  final FirebaseCloudStorage cloudService = FirebaseCloudStorage();
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      if (args.containsKey('shop')) {
        shop = args['shop'] as Shop;
        imgList.add(shop!.shopImagePath);

        if (args.containsKey('rank')) {
          final rankValue = args['rank'];
          icons['rank']['value'] = rankValue != null
              ? rankValue.toString()
              : ''; // Ensure rank is a valid string
        }
        print('hehe$shop');

        icons.forEach((key, value) async {
          switch (key) {
            case 'shopLocation':
              icons[key]['value'] = shop?.shopLocation ?? '';
              break;
            case 'contactInfo':
              icons[key]['value'] = shop?.contactInfo['phone_number'] ?? '';
              break;
            case 'available hours':
              icons[key]['value'] = shop?.availableHours ?? '';
              break;
            case 'delivery':
              // Ensure delivery is a String, not a List
              icons = shop?.deliveryApps.isNotEmpty ?? false
                  ? {
                      ...icons,
                      'delivery': {
                        'icon': 'assets/icons/delivery.svg',
                        'value': shop?.deliveryApps,
                      }
                    }
                  : {
                      ...icons,
                      'delivery': {
                        'icon': 'assets/icons/delivery.svg',
                        'value': 'Not Available',
                      }
                    };
              break;
          }
        });
      } else {
        devtools.log('Invalid arguments passed to this screen.');
      }
    } else {
      devtools.log('No arguments passed to this screen.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    devtools.log('Shop: $shop');
    devtools.log('Icons: $icons');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Restaurant Information",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: isDarkMode
            ? Colors.grey[900]
            : Colors.white, // Dynamic AppBar color
        elevation: 0,
        iconTheme: IconThemeData(
            color: isDarkMode
                ? Colors.white
                : Colors.black), // Icon color based on theme
      ),
      backgroundColor: isDarkMode
          ? Colors.grey[900]
          : Colors.white, // Set background color to match AppBar
      body: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = false;
          });
        },
        child: Column(
          children: [
            // Image Slider Section
            SizedBox(
              height: AspectRatios.height * 0.2014218009478672985781990521327,
              child: Stack(
                children: [
                  PageView(
                    children: [
                      if (imgList.isNotEmpty)
                        Image.network(
                          imgList.first,
                          fit: BoxFit.contain,
                        ),
                    ],
                  ),

                  // Rating Badge
                  Transform.translate(
                    offset: const Offset(0, 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 198, 35),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          '${shop!.bayesianAverage.toStringAsFixed(1)} Stars | $reviews + Reviews',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              shop!.shopName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          maxLines: isExpanded == false ? 1 : null,
                          overflow: isExpanded == true
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          shop!.description,
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Column(
                        children: [
                          ...List.generate(
                            icons.length,
                            (index) {
                              final key = icons.keys.elementAt(index);
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        icons[key]['icon'],
                                        width:
                                            AspectRatios.width * 0.06153846153,
                                        height:
                                            AspectRatios.height * 0.02843601895,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      SizedBox(
                                          width: AspectRatios.width * 0.025),
                                      Expanded(
                                        child: Transform.translate(
                                          offset: const Offset(0, 2.5),
                                          child: Text(
                                            '${index != 4 ? icons[key]['value'] : ''}${index == 0 ? 'st Place' : index == 4 ? shop?.deliveryApps.isNotEmpty ?? false ? icons[key]['value'].keys.first : 'Not Available On Delivery Apps' : ''}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AspectRatios.height * 0.03),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: -10,
                    right: 0,
                    child: Row(
                      children: [
                        ...List.generate(
                          socialLinks.length,
                          (index) {
                            final key = socialLinks.keys.elementAt(index);
                            return buildSocialIcon(
                                "assets/icons/$key.svg", socialLinks[key]!);
                          },
                        ),
                        buildSocialIcon("assets/icons/favorite_icon.svg", ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 198, 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                Get.toNamed(menuPageRoute, arguments: {
                  'shop': shop,
                });
              },
              child: const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSocialIcon(String assetPath, String url) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      padding: const EdgeInsets.all(5),
      visualDensity: const VisualDensity(horizontal: -4),
      icon: SvgPicture.asset(
        assetPath,
        width: AspectRatios.width * 0.05048717948717948717948717948718,
        height: AspectRatios.height * 0.02332938388625592417061611374408,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      onPressed: () => _launchUrl(url),
    );
  }

  Widget buildInfoRow(String iconPath, String text, {String? link}) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Widget padding = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: AspectRatios.width * 0.06153846153,
            height: AspectRatios.height * 0.02843601895,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          SizedBox(width: AspectRatios.width * 0.025),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
    return link != null
        ? GestureDetector(onTap: () => _launchUrl(link), child: padding)
        : padding;
  }
}
