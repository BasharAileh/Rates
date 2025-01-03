import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'menu_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RestaurantInformationPage extends StatefulWidget {
  const RestaurantInformationPage(
      {super.key, required this.rating, required this.restaurantName});

  final double rating;
  final String restaurantName;
  @override
  State<RestaurantInformationPage> createState() =>
      RestaurantInformationPageState();
}

class RestaurantInformationPageState extends State<RestaurantInformationPage> {
  final List<String> imgList = [
    'assets/images/testpic/babalyamen.jpg',
    'assets/images/testpic/raizmalee.jpg',
    'assets/images/testpic/zerbyan.jpg',
  ];
  final Map<String, String> socialLinks = {
    'facebook': 'https://web.facebook.com/babalyemenrestaurants/?_rdc=1&_rdr',
    'whatsapp': 'https://www.whatsapp.com/',
    'instagram': 'https://www.instagram.com',
  };
  final List<Map<String, String?>> infoRows = [
    {
      'icon': 'assets/icons/location.svg',
      'text':
          'Suleiman Al Assaf Complex, Princess Rahma El Hassan St 43, Amman',
      'link': 'geo:0,0?q=Jordan+University+St'
    },
    {
      'icon': 'assets/icons/phone.svg',
      'text': '0791010243',
      'link': 'tel:0791010243'
    },
    {'icon': 'assets/icons/watch.svg', 'text': '10 AM - 11 PM'},
    {'icon': 'assets/icons/delivery.svg', 'text': 'Careem - Talabat'},
    {'icon': 'assets/icons/Voucher.svg', 'text': 'No Vouchers exist currently'},
    {'icon': 'assets/icons/money.svg', 'text': '\$\$'},
  ];
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
      body: Column(
        children: [
          // Image Slider Section
          SizedBox(
              height: AspectRatios.height * 0.2014218009478672985781990521327,
              width: double.infinity,
              child: PageView(
                children: [
                  Image.asset(imgList[0], fit: BoxFit.cover),
                  Image.asset(imgList[1], fit: BoxFit.cover),
                  Image.asset(imgList[2], fit: BoxFit.cover),
                ],
              )),

          // Rating Badge
          Stack(
            children: [
              Transform.translate(
                offset: Offset(0, -AspectRatios.height * 0.065 / 2.5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 198, 35),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '${widget.rating} Stars | $reviews + Reviews',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Details Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.restaurantName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            rank,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            children: socialLinks.entries.map((entry) {
                              return buildSocialIcon(
                                  "assets/icons/${entry.key}.svg", entry.value);
                            }).toList(),
                          ),
                          buildSocialIcon("assets/icons/favorite_icon.svg", ''),
                        ],
                      ),
                      const Text(
                        "Yemeni food",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  const Text(
                    'Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: infoRows.map((row) {
                      return buildInfoRow(row['icon']!, row['text']!,
                          link: row['link']);
                    }).toList(),
                  )
                ],
              ),
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
              Get.to(() => MenuPage(
                    restaurantName: widget.restaurantName,
                    rating: widget.rating,
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
        ],
      ),
    );
  }

  Widget buildSocialIcon(String assetPath, String url) {
    return IconButton(
      padding: const EdgeInsets.all(5),
      visualDensity: const VisualDensity(horizontal: -4),
      // splashRadius: ,
      icon: SvgPicture.asset(assetPath,
          width: AspectRatios.width * 0.05048717948717948717948717948718,
          height: AspectRatios.height * 0.02332938388625592417061611374408),
      onPressed: () => _launchUrl(url),
    );
  }

  Widget buildInfoRow(String iconPath, String text, {String? link}) {
    Widget padding = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: AspectRatios.width * 0.03589743589743589743589743589744,
            height: AspectRatios.height * 0.02369668246445497630331753554502,
          ),
          SizedBox(width: AspectRatios.width * 0.025),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
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