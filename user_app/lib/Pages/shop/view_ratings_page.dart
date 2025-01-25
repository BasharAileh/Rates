// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/dialogs/redeem_dialog.dart';
import 'package:rates/services/cloud/cloud_instances.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

class ViewRating extends StatefulWidget {
  const ViewRating({
    super.key,
  });

  @override
  State<ViewRating> createState() => _ViewRatingState();
}

FirebaseCloudStorage cloudService = FirebaseCloudStorage();

class _ViewRatingState extends State<ViewRating> {
  late final String restaurantName;
  late final double rating;
  late final String mealName;
  late final String imagePath;
  late final String productID;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      final Map<String, dynamic> args = Get.arguments;
      productID = args['product_id'];
    }
    restaurantName = 'Bab Al Yamen';
    rating = 4.5;
    mealName = 'Shawarma';
    imagePath = 'assets/images/testpic/shawarma.jpg';
  }

  bool isFavorite = false;
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> reviews = [
    {
      'review': 'The rice was cold, not spicy enough',
      'rating': 2,
      'avatar': 'assets/images/Bara.jpeg'
    },
    {
      'review': 'took too long to get ready!',
      'rating': 3,
      'avatar': 'assets/images/Bashar_Akileh.jpg'
    },
    {
      'review': 'average',
      'rating': 3,
      'avatar': 'assets/images/mhmd_adass.png'
    },
    {'review': 'loved it!', 'rating': 5, 'avatar': 'assets/images/Bara.jpeg'},
    {
      'review': 'tasty',
      'rating': 4,
      'avatar': 'assets/images/Bashar_Akileh.jpg'
    },
    {
      'review': 'eat in restaurant, it\'s a lot better and tasty',
      'rating': 4,
      'avatar': 'assets/images/mhmd_adass.png'
    },
    {
      'review': 'The rice was cold, not spicy enough',
      'rating': 1,
      'avatar': 'assets/images/Bara.jpeg'
    },
    {
      'review': 'took too long to get ready!',
      'rating': 3,
      'avatar': 'assets/images/Bashar_Akileh.jpg'
    },
    {
      'review': 'average',
      'rating': 3,
      'avatar': 'assets/images/mhmd_adass.png'
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    late final Product product;
    late final Shop shop;
    late final bool isImageAvailable;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Ratings",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: cloudService.getProductInfo(productID).then((value) async {
          product = value;
          return cloudService.getShopInfo(value.shopID).then((value) async {
            if (value != null) {
              shop = value;
            } else {
              throw Exception('Shop not found for shopID: ${product.shopID}');
            }
            isImageAvailable =
                await cloudService.isImageAvailable(value.shopImagePath);
            return isImageAvailable;
          });
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Info Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: AspectRatios.height * 0.059,
                        width: AspectRatios.width * 0.2,
                        child: CircleAvatar(
                          backgroundColor: isImageAvailable == true
                              ? Colors.transparent
                              : Colors.black,
                          child: isImageAvailable == false
                              ? SvgPicture.asset(
                                  'assets/logos/yallow_logo.svg',
                                  height: AspectRatios.height * 0.05,
                                  width: AspectRatios.width * 0.05,
                                  color: iconColor,
                                )
                              : Image.network(shop.shopImagePath),
                        )),
                    SizedBox(width: AspectRatios.width * 0.02),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.shopName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            'Rating of ${shop.bayesianAverage.toStringAsFixed(1)} stars',
                            style: TextStyle(fontSize: 11, color: textColor),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : iconColor,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ],
                ),
                SizedBox(height: AspectRatios.height * 0.02),
                // Meal Image and Details
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: Image.network(
                        product.productImagePath,
                        height: AspectRatios.height * 0.16,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: AspectRatios.width * 0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.primaryColor.withOpacity(0.5),
                            Colors.white.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ...List.generate(
                              product.bayesianAverage.floor(),
                              (index) => Icon(
                                Icons.star,
                                color: Colors.amber.withOpacity(0.8),
                                size: 20,
                              ),
                            ),
                            if ((product.bayesianAverage -
                                    product.bayesianAverage.floor()) >=
                                0.5)
                              Icon(
                                Icons.star_half,
                                color: Colors.amber.withOpacity(0.8),
                                size: 20,
                              ),
                            ...List.generate(
                              5 - product.bayesianAverage.ceil(),
                              (index) => Icon(
                                Icons
                                    .star_border, // Empty star for the remaining
                                color: Colors.amber.withOpacity(0.8),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              product.productName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              ' - ${product.productPrice.toString()}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          product.productDescription.isEmpty
                              ? 'No description available'
                              : product.productDescription,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const VerificationDialogPage(); // Show the verification dialog
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        backgroundColor:
                            const Color.fromARGB(255, 243, 198, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text('Rate',
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ],
                ),
                // Reviews Section
                Expanded(
                  child: FutureBuilder(
                    future: cloudService.getRates(productID),
                    builder: (context, snapshot) {
                      List<ProductRating>? rates = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        rates = snapshot.data as List<ProductRating>;
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Failed to load rates'),
                        );
                      }

                      print(productID);

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: rates?.length ?? 0,
                        itemBuilder: (context, index) {
                          final rate = rates![index];
                          print('[rate] $rate');
                          final review = reviews[index];
                          return Card(
                            color: Colors.white,
                            elevation: 0,
                            child: ListTile(
                              leading: FutureBuilder(
                                  future: cloudService.getUserInfo(rate.userID),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    print(rate.userID);
                                    print('snapshot.data ${snapshot.data}');
                                    return CircleAvatar(
                                      backgroundImage:
                                          AssetImage(review['avatar']),
                                      onBackgroundImageError: (_, __) {
                                        setState(() {
                                          review['avatar'] =
                                              'assets/images/default_avatar.png'; // Use fallback image
                                        });
                                      },
                                    );
                                  }),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rate.ratingText,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                      5,
                                      (starIndex) => SvgPicture.asset(
                                        'assets/icons/star.svg',
                                        colorFilter: starIndex <
                                                rate.ratingValue
                                            ? const ColorFilter.mode(
                                                Color.fromARGB(
                                                    255, 255, 193, 7),
                                                BlendMode.srcIn)
                                            : const ColorFilter.mode(
                                                Color.fromARGB(200, 0, 0, 0),
                                                BlendMode.srcIn),
                                        width: AspectRatios.width * 0.02,
                                        height: AspectRatios.height * 0.03,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
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
