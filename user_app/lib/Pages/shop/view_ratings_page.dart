import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
    late final Product product;
    late final Shop shop;
    late final bool isImageAvailable;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ratings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
          print('da product $product');
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rating of ${shop.bayesianAverage.toStringAsFixed(1)} stars',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ],
                ),
                SizedBox(height: AspectRatios.height * 0.02),
                // Meal Image and Details
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Image.network(
                    product.productImagePath,
                    height: AspectRatios.height * 0.16,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
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
                              mealName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' - ${product.productPrice.toString()}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Half chicken, rice, 2 spicy sauces',
                          style: TextStyle(fontSize: 11),
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
                        // Increase elevation for a more pronounced shadow
                      ),
                      child: const Text('Rate',
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ],
                ),
                // Reviews Section
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(review['avatar']),
                            onBackgroundImageError: (_, __) {
                              setState(() {
                                review['avatar'] =
                                    'assets/images/default_avatar.png'; // Use fallback image
                              });
                            },
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review['review'],
                                style: const TextStyle(fontSize: 13),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  5,
                                  (starIndex) => SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    color: starIndex < review['rating']
                                        ? const Color.fromARGB(255, 255, 193, 7)
                                        : const Color.fromARGB(200, 0, 0, 0),
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
