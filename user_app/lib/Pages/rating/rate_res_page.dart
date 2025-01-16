import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/Pages/shop/rest_info_page.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'package:rates/services/cloud/cloud_instances.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

class RateMealPage extends StatefulWidget {
  final String restaurant;
  final List<String> meals;
  final String rating;
  final String logo;

  const RateMealPage({
    super.key,
    required this.restaurant,
    required this.meals,
    required this.rating,
    required this.logo,
  });

  @override
  State<RateMealPage> createState() => RateMealPageState();
}

final FirebaseCloudStorage cloudService = FirebaseCloudStorage();
Map<String, double> ratings = {};
bool isRatingVisible = false;
late List<TextEditingController> _opinionController;

class RateMealPageState extends State<RateMealPage> {
  double mealRating = 0;
  final args = Get.arguments;

  final ProductRatingController controller = Get.put(ProductRatingController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rate your meals',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: FutureBuilder(
        future: cloudService.getReceiptInfo(args['order_id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> receiptInfo =
              snapshot.data as Map<String, dynamic>;

          _opinionController = List.generate(receiptInfo['products'].length,
              (index) => TextEditingController());

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              children: [
                // Header Section
                SizedBox(
                  height: 100,
                  child: buildRestaurantHeader(receiptInfo['shop_id']),
                ),
                SizedBox(height: 16),
                const Text(
                  "Rate the meals you enjoyed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Product List Section
                Expanded(
                  child: ListView.builder(
                    itemCount: receiptInfo['products'].length,
                    itemBuilder: (context, index) {
                      final productName =
                          receiptInfo['products'].keys.elementAt(index);
                      final product = receiptInfo['products'][productName];

                      return Column(
                        children: [
                          // Product Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'x${product['product_quantity'] ?? ''} ',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  productName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Obx(() {
                                return controller
                                            .isRatingVisible[productName] ??
                                        false == false
                                    ? IconButton(
                                        onPressed: () {
                                          controller
                                              .toggleVisibility(productName);
                                        },
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 30,
                                          color:
                                              Color.fromARGB(255, 255, 196, 45),
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          controller
                                              .toggleVisibility(productName);
                                        },
                                        child: const Text(
                                          'Rate',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 255, 196, 45),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                              }),
                            ],
                          ),

                          // Animated Rating Section
                          Obx(() {
                            final isVisible =
                                controller.isRatingVisible[productName] ??
                                    false;

                            return AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment: Alignment.topCenter,
                              child: isVisible
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Slider(
                                                value: controller
                                                        .ratings[productName] ??
                                                    0,
                                                onChanged: (value) {
                                                  controller.updateRating(
                                                      productName, value);
                                                },
                                                min: 0,
                                                max: 5,
                                                label: controller
                                                    .ratings[productName]
                                                    ?.toStringAsFixed(1),
                                                activeColor:
                                                    const Color.fromARGB(
                                                        255, 255, 196, 45),
                                              ),
                                            ),
                                            Text(
                                              "${(controller.ratings[productName] ?? 0).toStringAsFixed(1)} / 5",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        OpinionTextBox(
                                          controller: _opinionController[index],
                                          hintText:
                                              "How was the overall service at the restaurant?",
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            );
                          }),
                          SizedBox(
                            height: AspectRatios.height * 0.01,
                          )
                        ],
                      );
                    },
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            controller.ratings.forEach((key, value) async {
                              for (int number = 0;
                                  number <
                                      receiptInfo['products'][key]
                                          ['product_quantity'];
                                  number++) {
                                final productID =
                                    await cloudService.getProductID(
                                  key,
                                  receiptInfo['shop_id'],
                                );

                                final Product product = await cloudService
                                    .getProductInfo(productID);
                                Shop? shop = await cloudService
                                    .getShopInfo(receiptInfo['shop_id']);

                                cloudService.insertDocument(
                                  'product_rating',
                                  {
                                    'product_id': productID,
                                    'product_category_id': product.categoryID,
                                    'rating_value': value,
                                  },
                                );

                                if (shop != null) {
                                  await cloudService
                                      .incrementUserCategoryRatings(
                                    AuthService.firebase().currentUser!.id,
                                    shop.categoryID,
                                  );
                                }
                              }
                            });
                          } catch (_) {}

                          /* showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/verfication_success.svg',
                            width: AspectRatios.width * 0.2,
                            height: AspectRatios.height * 0.2,
                          ),
                          SizedBox(height: AspectRatios.height * 0.01),
                          const Text(
                            'Your ratings have been submitted!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 196, 45),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              Future.delayed(const Duration(seconds: 4), () {
                Navigator.pop(context);
                Navigator.pop(context);
              }); */
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 196, 45),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Submit Ratings",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              title: Text("We’re Sorry!"),
                              content:
                                  Text("Please let us know what went wrong."),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 33, 150, 243)),
                        child: const Text(
                          "This wasn’t what I ordered",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
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

// Reusable widget to build the restaurant header
Widget buildRestaurantHeader(String shopID) {
  Shop? shop;
  return LayoutBuilder(
    builder: (context, constraints) {
      print('constraints: $constraints');
      return GestureDetector(
        onTap: () {
          Get.to(() => RestaurantInformationPage());
        },
        child: FutureBuilder(
          future: cloudService.getShopInfo(shopID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              shop = snapshot.data;
            }
            return Column(
              children: [
                FutureBuilder(
                  future:
                      cloudService.isImageAvailable(shop?.shopImagePath ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      return Image.network(
                        height: constraints.maxHeight * 0.8,
                        width: constraints.maxWidth,
                        shop!.shopImagePath,
                      );
                    }
                    return const Icon(Icons.error);
                  },
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.2,
                  child: Text(
                    shop?.shopName ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            );
          },
        ),
      );
    },
  );
}

// Reusable footer buttons for submission and problem
Widget buildFooterButtons(BuildContext context) {
  final ProductRatingController controller = Get.put(ProductRatingController());
  return Center(
    child: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            /* showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/verfication_success.svg',
                            width: AspectRatios.width * 0.2,
                            height: AspectRatios.height * 0.2,
                          ),
                          SizedBox(height: AspectRatios.height * 0.01),
                          const Text(
                            'Your ratings have been submitted!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 196, 45),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              Future.delayed(const Duration(seconds: 4), () {
                Navigator.pop(context);
                Navigator.pop(context);
              }); */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 196, 45),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            "Submit Ratings",
            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text("We’re Sorry!"),
                content: Text("Please let us know what went wrong."),
              ),
            );
          },
          style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 33, 150, 243)),
          child: const Text(
            "This wasn’t what I ordered",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

// Reusable Rating Slider Widget
class RatingSlider extends StatelessWidget {
  final String? label;
  final double currentRating;
  final ValueChanged<double> onChanged;

  const RatingSlider({
    super.key,
    this.label,
    required this.currentRating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? "",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SliderTheme(
                data: const SliderThemeData(
                  valueIndicatorTextStyle:
                      TextStyle(fontSize: 10, color: Colors.black),
                ),
                child: Slider(
                  value: currentRating,
                  onChanged: onChanged,
                  min: 0.5,
                  max: 5,
                  divisions: 10,
                  label: currentRating.toStringAsFixed(1),
                  activeColor: const Color.fromARGB(255, 255, 196, 45),
                ),
              ),
            ),
            Text(
              "${currentRating.toStringAsFixed(1)} / 5",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

/* 
// Restaurant Rating Card using RatingSlider
class RestaurantRatingCard extends StatefulWidget {
  final String restaurantName;

  const RestaurantRatingCard({super.key, required this.restaurantName});

  @override
  RestaurantRatingCardState createState() => RestaurantRatingCardState();
}

class RestaurantRatingCardState extends State<RestaurantRatingCard> {
  bool isRatingVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AspectRatios.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Restaurant Services",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              isRatingVisible
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isRatingVisible = false; // Collapse the slider
                        });
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        size: AspectRatios.height * 0.045,
                        color: const Color.fromARGB(255, 255, 196, 45),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          isRatingVisible = true; // Expand the slider
                        });
                      },
                      child: const Text(
                        "Rate",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 196, 45),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          if (isRatingVisible) ...[
            RatingSlider(
              label: "Delivery",
              currentRating: ratings["Delivery"]!,
              onChanged: (value) {
                setState(() {
                  ratings["Delivery"] = value;
                });
              },
            ),
            RatingSlider(
              label: "Cleanliness",
              currentRating: ratings["Cleanliness"]!,
              onChanged: (value) {
                setState(() {
                  ratings["Cleanliness"] = value;
                });
              },
            ),
            RatingSlider(
              label: "Pricing",
              currentRating: ratings["Pricing"]!,
              onChanged: (value) {
                setState(() {
                  ratings["Pricing"] = value;
                });
              },
            ),
            const OpinionTextBox(
              hintText: "How was the overall service at the restaurant?",
            )
          ],
        ],
      ),
    );
  }
}
 */

// Meal Rating Card using RatingSlider
class MealRatingCard extends StatefulWidget {
  final String mealName;
  final double currentRating;
  final ValueChanged<double> onChanged;
  final int numberOfItems;

  const MealRatingCard({
    super.key,
    required this.mealName,
    required this.currentRating,
    required this.onChanged,
    required this.numberOfItems,
  });

  @override
  MealRatingCardState createState() => MealRatingCardState();
}

class MealRatingCardState extends State<MealRatingCard>
    with SingleTickerProviderStateMixin {
  bool isRatingVisible = false;
  double currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AspectRatios.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('x${widget.numberOfItems} ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Expanded(
              child: Text(
                widget.mealName,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            isRatingVisible
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isRatingVisible = false; // Collapse the slider
                      });
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_up,
                      size: AspectRatios.height * 0.040,
                      color: const Color.fromARGB(255, 255, 196, 45),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        isRatingVisible = true; // Expand the slider
                      });
                    },
                    child: const Text(
                      'Rate',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 196, 45),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isRatingVisible
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: const SliderThemeData(
                              valueIndicatorTextStyle:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            child: Slider(
                              value: currentRating,
                              onChanged: (value) {
                                setState(() {
                                  currentRating = value; // Update local state
                                });
                                widget.onChanged(
                                    value); // Call onChanged from parent to update external state
                              },
                              min: 0,
                              max: 5,
                              divisions: 10,
                              label: currentRating.toStringAsFixed(1),
                              activeColor:
                                  const Color.fromARGB(255, 255, 196, 45),
                            ),
                          ),
                        ),
                        Text(
                          "${currentRating.toStringAsFixed(1)} / 5",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    OpinionTextBox(
                      controller: _opinionController[widget.numberOfItems],
                      hintText: "Share your thoughts about the meal...",
                    ),
                  ],
                )
              : Container(),
        ),
      ],
    );
  }
}

class OpinionTextBox extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const OpinionTextBox(
      {super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(left: 13, right: 13),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: TextField(
        maxLength: 200,
        cursorColor: const Color.fromARGB(255, 255, 196, 45),
        maxLines: 2, // Allow multi-line input
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }
}

class ProductRatingController extends GetxController {
  // Tracks which product's rating is visible
  final isRatingVisible = {}.obs; // Key: product_name, Value: visibility (bool)

  // Tracks ratings for each product
  final ratings = {}.obs; // Key: product_name, Value: rating (double)

  // Toggle visibility for a product
  void toggleVisibility(String productName) {
    isRatingVisible[productName] = !(isRatingVisible[productName] ?? false);
  }

  // Update rating for a product
  void updateRating(String productName, double value) {
    ratings[productName] = value;
  }
}
