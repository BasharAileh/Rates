import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/services/cloud/cloud_instances.dart';
import '../other/favorites_page.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with TickerProviderStateMixin {
  late final Map args;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      args = Get.arguments;
    } else {
      args = {};
    }
  }

  List<Map<String, dynamic>> restaurantList = List.generate(
    10,
    (index) => {
      'name': 'Restaurant #$index',
      'rating': 1.5 + (index + 1 % 2) * 0.5,
      'image': 'assets/images/Bashar_Akileh.jpg',
      'isFavorite': false,
      'index': index,
    },
  );

  Future<bool> isImageAvailable(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void _sortRestaurants(String criteria) {
    setState(() {
      if (criteria == 'Rating') {
        restaurantList.sort((a, b) => b['rating'].compareTo(a['rating']));
      } else if (criteria == 'Alphabetical') {
        restaurantList.sort((a, b) => a['name'].compareTo(b['name']));
      }
    });
  }

  void toggleFavorite(int index) {
    final previousState = restaurantList[index]['isFavorite'];

    setState(() {
      restaurantList[index]['isFavorite'] = !previousState;
    });

    showSnackBar(restaurantList[index]['isFavorite'], index);
  }

  void showSnackBar(bool isFavorite, int index) {
    String snackBarTitle =
        isFavorite ? "Added to Favorite List" : "Removed from Favorite List";
    String snackBarMessage = isFavorite
        ? "The item has been successfully added to your favorite list."
        : "The item has been removed from your favorite list.";

    Get.snackbar(
      snackBarTitle,
      snackBarMessage,
      titleText: Text(
        snackBarTitle,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        snackBarMessage,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      backgroundColor: Colors.grey,
      colorText: const Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.only(top: 10, left: 7, right: 7),
      padding: const EdgeInsets.all(5),
      boxShadows: [
        const BoxShadow(
          color: Color.fromARGB(255, 56, 56, 56),
          offset: Offset(0, 2),
          blurRadius: 5,
          spreadRadius: 0.5,
        ),
      ],
    );
  }

  Widget restaurantCard({
    required String name,
    required String image,
    required double rating,
    required bool isFavorite,
    required VoidCallback onFavoriteToggle,
    required VoidCallback onDetailsPressed,
    required int index,
  }) {
    Color ratingColor;
    String ratingText = "Rating of ";

    if (rating >= 4) {
      ratingColor = Colors.green;
    } else if (rating >= 3) {
      ratingColor = Colors.orange;
    } else {
      ratingColor = Colors.red;
    }

    return InkWell(
      onTap: onDetailsPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.withOpacity(0)
                  : Colors.white.withOpacity(0),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                width: 69,
                height: 69,
                child: image.contains('http')
                    ? Image.network(
                        image,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey[900],
                        child: SvgPicture.asset(
                          'assets/logos/yallow_logo.svg',
                          height: 50,
                          width: 50,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "#${index}st Place",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.yellow
                                : Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        ratingText,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        "$rating stars",
                        style: TextStyle(
                          color: ratingColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "View Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollControllerWithGetX controller =
        Get.put(ScrollControllerWithGetX());
    devtools.log('Arguments: $args');
    final category = args['category'];
    final categoryID = args['category_id'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          category,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(
                    favorites: restaurantList
                        .where((restaurant) => restaurant['isFavorite'])
                        .toList(),
                    onRemoveFavorite: (index) {
                      setState(() {
                        restaurantList[index]['isFavorite'] = false;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: AspectRatios.width * 0.045),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Discover and Rate",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: SizedBox(
                      height: AspectRatios.height * 0.03197265625,
                      width: AspectRatios.width * 0.4807692307692308,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for restaurants',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white54
                                : Colors.black,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white54
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.filter_list,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    onSelected: _sortRestaurants,
                    itemBuilder: (BuildContext context) {
                      return ['Rating', 'Alphabetical']
                          .map((String choice) => PopupMenuItem<String>(
                                value: choice,
                                child: Text(
                                  choice,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ))
                          .toList();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('shop')
                    .orderBy('bayesian_average', descending: true)
                    .where('category_id', isEqualTo: categoryID)
                    .snapshots(),
                builder: (context, snapshot) {
                  late List<Shop> shops;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    shops = snapshot.data!.docs
                        .map(
                          (e) => Shop.fromMap(
                            e.data() as Map<String, dynamic>,
                            shopID: e.id,
                          ),
                        )
                        .toList();
                  }
                  return Expanded(
                    child: ListView.builder(
                      controller: controller.scrollController,
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        final restaurant = shops[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: FutureBuilder(
                            future: isImageAvailable(restaurant.shopImagePath),
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  restaurantCard(
                                    name: restaurant.shopName,
                                    image: restaurant.shopImagePath,
                                    rating: restaurant.bayesianAverage,
                                    index: index + 1,
                                    isFavorite: false,
                                    onFavoriteToggle: () =>
                                        toggleFavorite(index),
                                    onDetailsPressed: () {
                                      Get.toNamed(
                                        restInfoRoute,
                                        arguments: {
                                          'shop': restaurant,
                                          'rank': index + 1,
                                        },
                                      );
                                    },
                                  ),
                                  shops.length - 1 == index
                                      ? const SizedBox(
                                          height: 40,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        return controller.showScrollToTopButton.value
            ? Align(
                alignment: Alignment.bottomCenter,
                child: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: IconButton(
                    color: Colors.black,
                    onPressed: controller.scrollToTop,
                    icon: const Icon(
                      Icons.arrow_upward,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}

class AnimatedListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const AnimatedListWidget({super.key, required this.items});

  @override
  _AnimatedListWidgetState createState() => _AnimatedListWidgetState();
}

class _AnimatedListWidgetState extends State<AnimatedListWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late List<Map<String, dynamic>> _oldItems;

  @override
  void initState() {
    super.initState();
    _oldItems = List.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant AnimatedListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateList(widget.items);
  }

  void _updateList(List<Map<String, dynamic>> newItems) {
    for (var oldItem in _oldItems) {
      if (!newItems.contains(oldItem)) {
        int index = _oldItems.indexOf(oldItem);
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => _buildItem(oldItem, animation),
        );
      }
    }

    for (var newItem in newItems) {
      if (!_oldItems.contains(newItem)) {
        int index = newItems.indexOf(newItem);
        _listKey.currentState?.insertItem(index);
      }
    }

    _oldItems = List.from(newItems);
  }

  Widget _buildItem(Map<String, dynamic> item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Text(item['name']),
        subtitle: Text('Rating: ${item['rating']}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: widget.items.length,
      itemBuilder: (context, index, animation) {
        return _buildItem(widget.items[index], animation);
      },
    );
  }
}

class ScrollControllerWithGetX extends GetxController {
  ScrollController scrollController = ScrollController();
  var showScrollToTopButton = false.obs;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      showScrollToTopButton.value =
          scrollController.position.pixels > 500;
    });
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}


/* 
 Expanded(
                child: ListView.builder(
                  itemCount: restaurantList.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurantList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: restaurantCard(
                        name: restaurant['name'],
                        image: restaurant['image'],
                        rating: restaurant['rating'],
                        isFavorite: restaurant['isFavorite'],
                        onFavoriteToggle: () => toggleFavorite(index),
                        onDetailsPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RestaurantInformationPage(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
 */