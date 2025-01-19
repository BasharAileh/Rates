import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/dialogs/redeem_dialog.dart';
import 'package:rates/services/cloud/cloud_instances.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

FirebaseCloudStorage cloudService = FirebaseCloudStorage();

class MenuPage extends StatefulWidget {
  const MenuPage({
    super.key,
  });

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  bool isFavorite = false;
  String searchQuery = "";
  late final Shop shop;

  @override
  void initState() {
    super.initState();
    var args = Get.arguments;
    if (args != null) {
      shop = args['shop'];
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Menu',
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Discover and rate",
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 93, 92, 102)),
                ),
                SizedBox(
                    width: AspectRatios.width *
                        0.02), // Add some spacing between the columns
                SizedBox(
                  height: AspectRatios.height * 0.04,
                  width: AspectRatios.width * 0.55,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search for a meal',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 15.0), // Adjusted padding
                    ),
                    style: TextStyle(
                        fontSize:
                            AspectRatios.width * 0.035), // Adjusted font size
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: AspectRatios.height * 0.02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: cloudService.isImageAvailable(shop.shopImagePath),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data == true) {
                          return Container(
                            width: AspectRatios.width * 0.12,
                            height: AspectRatios.height * 0.055,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(shop.shopImagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      }
                      return Container(
                        width: AspectRatios.width * 0.12,
                        height: AspectRatios.height * 0.055,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/testpic/babalyamen.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                SizedBox(
                    width: AspectRatios.width *
                        0.02), // Add some spacing between the columns
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
                        'Rating of ${shop.bayesianAverage}',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.black,
                  ),
                  onPressed: toggleFavorite,
                ),
              ],
            ),
            SizedBox(height: AspectRatios.height * 0.02),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('product')
                  .where('shop_id', isEqualTo: shop.shopID)
                  .orderBy('bayesian_average', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                final String productID;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No products found'),
                  );
                }
                if (snapshot.hasData) {
                  productID = snapshot.data!.docs.first.id;
                } else {
                  productID = '';
                }
                return Column(
                  children: snapshot.data!.docs
                      .map<Widget>((DocumentSnapshot product) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    Product? productData;

                    if (snapshot.hasData) {
                      productData = Product.fromMap(
                          product.data() as Map<String, dynamic>);
                    }

                    return FutureBuilder(
                        future: cloudService.isImageAvailable(
                            productData?.productImagePath ?? ''),
                        builder: (context, snapshot) {
                          print(snapshot.connectionState);
                          String? imageUrl;

                          if (snapshot.hasData) {
                            if (snapshot.data == true) {
                              imageUrl = productData?.productImagePath;
                            }
                          }
                          return MealCard(
                            menuItem: {
                              "name": product['product_name'],
                              "image": imageUrl,
                              'product_id': productID,
                            },
                          );
                        });
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.menuItem,
  });

  final Map<String, dynamic> menuItem;
  @override
  Widget build(BuildContext context) {
    print('menuItem: $menuItem');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            await Get.toNamed(viewRatingRoute, arguments: {
              'product_id': menuItem['product_id'],
            });
          },
          child: FutureBuilder(
            future: cloudService.isImageAvailable(menuItem["image"]),
            builder: (context, snapshot) {
              bool isImageAvailable = false;
              print(menuItem);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                isImageAvailable = snapshot.data!;
              }

              return Container(
                height: AspectRatios.height * 0.16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  image: DecorationImage(
                    image: isImageAvailable == true
                        ? NetworkImage(menuItem["image"])
                        : const AssetImage('assets/images/testpic/zerbyan.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromARGB(190, 0, 0, 0),
                              Color.fromARGB(46, 0, 0, 0),
                            ],
                          ), // Transparent black overlay
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 4,
                            left: 16.0,
                            right: 4.0,
                            bottom: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    menuItem["name"] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AspectRatios.width * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Row(
                                    children: [
                                      Text(
                                        'view ratings and comments',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton(
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
                                        vertical: 1, horizontal: 0),
                                    backgroundColor:
                                        const Color.fromARGB(255, 243, 198, 35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    // Increase elevation for a more pronounced shadow
                                  ),
                                  child: const Text('Rate',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: AspectRatios.height * 0.02),
      ],
    );
  }
}

class Restaurant {
  final String name;
  final double rating;
  final List<Map<String, String>> menuItems;

  Restaurant({
    required this.name,
    required this.rating,
    required this.menuItems,
  });
}

final Restaurant restaurant = Restaurant(
  name: "Bab el-yamen",
  rating: 3.5,
  menuItems: [
    {"name": "Mandi Meal", "image": "assets/images/testpic/raizmalee.jpg"},
    {"name": "Mansaf Meal", "image": "assets/images/testpic/zerbyan.jpg"},
    {"name": "Zerbyan Meal", "image": "assets/images/testpic/raizmalee.jpg"},
    {"name": "Kabseh Meal", "image": "assets/images/testpic/zerbyan.jpg"},
    {"name": "Ozii Meal", "image": "assets/images/testpic/raizmalee.jpg"},
  ],
);
