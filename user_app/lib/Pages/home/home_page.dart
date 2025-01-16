import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'package:rates/services/auth/auth_user.dart';
import 'package:rates/services/cloud/cloud_instances.dart';
import 'package:rates/services/cloud/cloud_storage_exception.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:developer' as devtools show log;

FirebaseCloudStorage cloudStorage = FirebaseCloudStorage();
late String path;
String? categoryID = 'food';

List<String> categories = ["Food", "Services", "Clothes", "Education", "Cars"];
late List<List<List<Shop>>> shops;
bool showIndicator = false;
List<String> categoryIDs = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<PageController> _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = List.generate(3, (index) => PageController());
    shops = List.generate(5, (index) => List.generate(3, (index) => []));
    _initializeCategoryIDs();
  }

  @override
  void dispose() {
    for (var controller in _pageController) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeCategoryIDs() async {
    categoryIDs = await Future.wait(categories.map((category) async {
      try {
        return await cloudStorage.getCategoryID(category);
      } on CategoryNotFoundException catch (e) {
        devtools.log('Caught CategoryNotFoundException: ${e.toString()}');
        return '20'; // Default fallback category ID
      } catch (e, stacktrace) {
        devtools.log('Caught general exception: $e');
        devtools.log('Stacktrace: $stacktrace');
        return '20'; // Default fallback category ID
      }
    }).toList());

    // Once categoryIDs are fetched, set state to trigger UI update
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FirebaseCloudStorage cloudStorage = FirebaseCloudStorage();
    AuthUser user = AuthService.firebase().currentUser!;
    devtools.log('Category IDs: $categoryIDs');
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.white, // Dynamic background color
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AspectRatios.width * 0.07307692307,
              ),
              child: Column(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/logos/black_logo.svg',
                      height: AspectRatios.height * 0.04333333333,
                      width: AspectRatios.width * 0.14871794871,
                      color: isDarkMode ? Colors.white : Colors.grey[900], // Dynamic logo color
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: cloudStorage.getUserStream(user.id),
                          builder: (context, snapshot) {
                            final userData =
                                snapshot.data?.data() as Map<String, dynamic>?;

                            if (userData != null) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  color: Colors.black,
                                  strokeWidth: 2,
                                );
                              }
                              if (snapshot.hasError) {
                                devtools.log(snapshot.error.toString());
                                return const Text('An error occurred');
                              }
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return const SizedBox();
                              }

                              if (userData['is_email_verified'] == false) {
                                return Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        height: AspectRatios.height * 0.03444444444,
                                        decoration: BoxDecoration(
                                          color: AppColors.verificationSuccessColor
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: isDarkMode ? Colors.white : Colors.black, // Dynamic icon color
                                              size: AspectRatios.height *
                                                  0.02444444444,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Please verify your email.',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                );
                              } else {
                                return SizedBox(
                                    height:
                                        15 + (AspectRatios.height * 0.03444444444));
                              }
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map(
                        (category) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: AspectRatios.width * 0.03607692307,
                            ),
                            child: SizedBox(
                              width: AspectRatios.width * 0.14256410256,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      devtools.log(FirebaseAuth.instance.currentUser
                                          .toString());
                                    },
                                    child: SizedBox(
                                      width: AspectRatios.width * 0.10256410256,
                                      height:
                                          AspectRatios.heightWithoutAppBar * 0.044,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: AspectRatios.height * 0.044,
                                            width:
                                                AspectRatios.width * 0.10256410256,
                                          ),
                                          Center(
                                            child: SvgPicture.asset(
                                              'assets/icons/${category.toLowerCase()}_icon.svg',
                                              width: AspectRatios.width *
                                                  0.08974358974,
                                              height: AspectRatios.height * 0.044,
                                               // Dynamic icon color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: AspectRatios.height * 0.01,
                                  ),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  SizedBox(
                    height: AspectRatios.height * 0.02,
                  ),
                  ...List.generate(
                    3,
                    (verticalIndex) {
                      List<Map<String, String>> info = [
                        {
                          'title': 'Monthly Finest',
                          'content': "assets/images/FireFly_Logo.png",
                        },
                        {
                          'title': 'Yearly Finest',
                          'content': "assets/images/_4chicks_logo.png",
                        },
                        {
                          'title': 'Rating Experts',
                          'content': "assets/images/CloudShot_logo.png",
                        },
                      ];
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: AspectRatios.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    info[verticalIndex]['title']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                                    ),
                                  ),
                                  Text(
                                    'Food',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700], // Dynamic text color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AspectRatios.height * 0.01,
                          ),
                          Container(
                            height: AspectRatios.height * 0.153,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 243, 198, 35),
                                  Color.fromARGB(255, 255, 166, 0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.1, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: PageView.builder(
                                controller: _pageController[verticalIndex],
                                onPageChanged: (value) {},
                                itemCount: 5,
                                itemBuilder: (context, horizontalIndex) {
                                  try {
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: getQueryStream(
                                          verticalIndex, horizontalIndex),
                                      builder: (context, snapshot) {
                                        try {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(
                                              backgroundColor: Colors.transparent,
                                              color: Colors.black,
                                              strokeWidth: 2,
                                            );
                                          }
                                          if (snapshot.hasError) {
                                            shops[horizontalIndex]
                                                [verticalIndex] = [];
                                            devtools.log(snapshot.error.toString());
                                            return const Text('An error occurred');
                                          }
                                          if (!snapshot.hasData ||
                                              snapshot.data!.docs.isEmpty) {
                                            if (shops[horizontalIndex]
                                                    [verticalIndex]
                                                .isEmpty) {
                                              shops[horizontalIndex]
                                                  [verticalIndex] = [];
                                            }
                                          }

                                          if (snapshot.hasData) {
                                            List<Shop> shopList = snapshot
                                                .data!.docs
                                                .map((doc) => Shop.fromMap(
                                                    doc.data()
                                                        as Map<String, dynamic>,
                                                    shopID: doc.id))
                                                .toList();
                                            shops[horizontalIndex][verticalIndex] =
                                                shopList;
                                          }
                                        } on CategoryNotFoundException catch (e) {
                                          devtools.log(
                                              'Caught CategoryNotFoundException: ${e.toString()}');
                                        } catch (e, stacktrace) {
                                          devtools
                                              .log('Caught general exception: $e');
                                          devtools.log('Stacktrace: $stacktrace');
                                        }
                                        return InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                              topRatedRoute,
                                              arguments: {
                                                'category':
                                                    categories[horizontalIndex],
                                                'category_id':
                                                    categoryIDs[horizontalIndex],
                                              },
                                            );
                                          },
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              try {
                                                if (shops[horizontalIndex]
                                                        [verticalIndex]
                                                    .isEmpty) {
                                                  return Center(
                                                    child: Text(
                                                      '${categories[horizontalIndex]}\n Coming Soon',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      ...List.generate(
                                                        3,
                                                        (index) {
                                                          shops[horizontalIndex][
                                                                      verticalIndex]
                                                                  .isEmpty
                                                              ? showIndicator = true
                                                              : shops[horizontalIndex]
                                                                          [
                                                                          verticalIndex][index ==
                                                                              0
                                                                          ? 1
                                                                          : index ==
                                                                                  1
                                                                              ? 0
                                                                              : 2]
                                                                      .shopImagePath
                                                                      .isEmpty
                                                                  ? showIndicator =
                                                                      true
                                                                  : showIndicator =
                                                                      false;
                                                          double imageSize =
                                                              AspectRatios.height *
                                                                  0.027;
                                                          double
                                                              imageSizeWithPadding =
                                                              AspectRatios.height *
                                                                      0.027 +
                                                                  AspectRatios
                                                                          .height *
                                                                      0.01;
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical: constraints
                                                                          .maxHeight *
                                                                      0.05,
                                                                ),
                                                                child: showIndicator == 
                                                                        true
                                                                    ? CircleAvatar(
                                                                        radius:
                                                                            imageSize,
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        child:
                                                                            const CircularProgressIndicator(
                                                                          backgroundColor:
                                                                              Colors
                                                                                  .white,
                                                                          color: Colors
                                                                              .black,
                                                                          strokeWidth:
                                                                              2,
                                                                        ),
                                                                      )
                                                                    : FutureBuilder(
                                                                        future: cloudStorage.isImageAvailable(shops[horizontalIndex]
                                                                                [
                                                                                verticalIndex][index == 
                                                                                    1
                                                                                ? 0
                                                                                : index == 0 
                                                                                    ? 1 
                                                                                    : 2]
                                                                            .shopImagePath),
                                                                        builder:
                                                                            (context,
                                                                                snapShot) {
                                                                          if (snapShot
                                                                                  .connectionState ==
                                                                              ConnectionState
                                                                                  .waiting) {
                                                                            return CircleAvatar(
                                                                              radius:
                                                                                  imageSize,
                                                                              backgroundColor:
                                                                                  Colors.white,
                                                                              child:
                                                                                  const CircularProgressIndicator(
                                                                                backgroundColor:
                                                                                    Colors.white,
                                                                                color:
                                                                                    Colors.black,
                                                                                strokeWidth:
                                                                                    2,
                                                                              ),
                                                                            );
                                                                          }
                                                                          if (snapShot
                                                                                  .hasError ||
                                                                              snapShot.data == 
                                                                                  false) {
                                                                            return CircleAvatar(
                                                                                radius:
                                                                                    imageSize,
                                                                                backgroundColor:
                                                                                    Colors.white,
                                                                                child: const Icon(Icons.error));
                                                                          }
                                                                          return CircleAvatar(
                                                                            radius:
                                                                                imageSize,
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            backgroundImage:
                                                                                NetworkImage(
                                                                              shops[horizontalIndex][verticalIndex][index == 1
                                                                                      ? 0
                                                                                      : index == 0
                                                                                          ? 1
                                                                                          : 2]
                                                                                  .shopImagePath,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                              ),
                                                              Flexible(
                                                                child: Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: isDarkMode ? Colors.grey[800] : Colors.white, // Dynamic container color
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .only(
                                                                        topLeft: Radius
                                                                            .circular(
                                                                                10),
                                                                        topRight: Radius
                                                                            .circular(
                                                                                10),
                                                                      ),
                                                                    ),
                                                                    height: index == 1
                                                                        ? constraints
                                                                                .maxHeight -
                                                                            imageSizeWithPadding
                                                                        : index == 0
                                                                            ? constraints.maxHeight *
                                                                                0.35
                                                                            : constraints.maxHeight *
                                                                                0.23,
                                                                    width: constraints
                                                                            .maxWidth *
                                                                        0.12,
                                                                    child:
                                                                        index == 1
                                                                            ? Align(
                                                                                alignment:
                                                                                    Alignment.topCenter,
                                                                                child:
                                                                                    Column(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 4.0),
                                                                                      child: Transform.translate(
                                                                                        offset: const Offset(2, 0),
                                                                                        child: SvgPicture.asset(
                                                                                          'assets/icons/Crown.svg',
                                                                                          width: constraints.maxWidth * 0.06923076923,
                                                                                          height: constraints.maxHeight * 0.12605042016,
                                                                                          color: isDarkMode ? Colors.white : Colors.black, // Dynamic icon color
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      '1',
                                                                                      style: TextStyle(
                                                                                        fontSize: 17,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            : Align(
                                                                                alignment:
                                                                                    Alignment.center,
                                                                                child:
                                                                                    Text(
                                                                                  index == 0 ? '2' : '3',
                                                                                  style: TextStyle(
                                                                                    fontSize: 17,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                                                                                  ),
                                                                                ),
                                                                              )),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                }
                                              } catch (e) {
                                                devtools.log(e.toString());
                                                return Center(
                                                  child: Text(
                                                    '${categories[horizontalIndex]}\n Coming Soon',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                      color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                                                      fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  } on CategoryNotFoundException catch (e) {
                                    devtools.log(e.toString());
                                  } catch (e) {
                                    devtools.log(e.toString());
                                    return const Text(
                                        'An error occurred. Please try again later.');
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: AspectRatios.height * 0.01,
                          ),
                          Center(
                            child: SmoothPageIndicator(
                              controller: _pageController[verticalIndex],
                              count: 5,
                              effect: WormEffect(
                                activeDotColor:
                                    const Color.fromARGB(255, 255, 196, 45),
                                dotHeight: AspectRatios.height * 0.007,
                                dotWidth: AspectRatios.width * 0.015,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CurrentCategoryController extends GetxController {
  var currentIndex = 0.obs; // Reactive variable for the selected index

  void changePage(int index) {
    currentIndex.value = index;
  }
}

Stream<QuerySnapshot> getQueryStream(int verticalIndex, int horizontalIndex) {
  devtools
      .log('verticalIndex: $verticalIndex, horizontalIndex: $horizontalIndex');
  if (categoryIDs.isNotEmpty) {
    if (verticalIndex == 0) {
      // Fetching from 'shop' with 'bayesian_average'
      return FirebaseFirestore.instance
          .collection('shop')
          .where('category_id', isEqualTo: categoryIDs[horizontalIndex])
          .orderBy('bayesian_average', descending: true)
          .limit(3)
          .snapshots();
    } else if (verticalIndex == 1) {
      // Fetching from 'shop' with 'annual_bayesian_average'
      return FirebaseFirestore.instance
          .collection('shop')
          .where('category_id', isEqualTo: categoryIDs[horizontalIndex])
          .orderBy('annual_bayesian_average', descending: true)
          .limit(3)
          .snapshots();
    } else {
      // Fetching from 'user' collection
      return FirebaseFirestore.instance
          .collection('user')
          .orderBy('number_of_ratings', descending: true)
          .limit(3)
          .snapshots();
    }
  } else {
    return const Stream.empty(); // No valid query, return empty stream
  }
}



/*  Container(
                      height: AspectRatios.height * 0.153,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: const [
                            Color.fromARGB(255, 243, 198, 35),
                            Color.fromARGB(255, 255, 166, 0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.1, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ...List.generate(
                                3,
                                (index) {
                                  double imageSize =
                                      AspectRatios.height * 0.027;
                                  double imageSizeWithPadding =
                                      AspectRatios.height * 0.027 +
                                          AspectRatios.height * 0.01;
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical:
                                              constraints.maxHeight * 0.05,
                                        ),
                                        child: CircleAvatar(
                                          radius: imageSize,
                                          backgroundImage: AssetImage(
                                              'assets/images/_4chicks_logo.png'),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            height: index == 1
                                                ? constraints.maxHeight -
                                                    imageSizeWithPadding
                                                : index == 0
                                                    ? constraints.maxHeight *
                                                        0.35
                                                    : constraints.maxHeight *
                                                        0.23,
                                            width: constraints.maxWidth * 0.12,
                                            child: index == 1
                                                ? Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 4.0),
                                                          child: Transform
                                                              .translate(
                                                            offset:
                                                                Offset(2, 0),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/icons/Crown.svg',
                                                              width: constraints
                                                                      .maxWidth *
                                                                  0.06923076923,
                                                              height: constraints
                                                                      .maxHeight *
                                                                  0.12605042016,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '1',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      index == 0 ? '2' : '3',
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                    ),
                                                  )),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ), */

//adas code with bara's changes

/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'package:rates/services/auth/auth_user.dart';
import 'dart:developer' as devtools show log;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import smooth page indicator

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> categoriess = [
    "Services",
    "Food",
    "Cloths",
    "Education",
    "Cars"
  ]; // Add categories
  String mainCurrentCategoryTitle = "Food";
  String mfCurrentCategoryTitle = "Food";
  String yfCurrentCategoryTitle = "Food";
  String reCurrentCategoryTitle = "Food";
  PageController pageController =
      PageController(); // Page controller for the swiping
  int currentPage = 0; // Current page for the indicator
  late bool showVerificationMessage; // Controls the verification message
  bool emailVerified = false; // Controls the success message
  @override
  void initState() {
    super.initState();
    AuthUser? user = AuthService.firebase().currentUser;
    if (user != null) {
      if (!user.isEmailVerified) {
        showVerificationMessage = true;
      } else {
        showVerificationMessage = false;
      }
    }
  }

  void showSuccessMessage() {
    setState(() {
      emailVerified = true; // Show the success message
    });

    // Automatically hide success message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        emailVerified = false; // Hide the success message
      });
    });
  }

  void showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Verify Email"),
        content: const Text("Are you sure you want to verify your email?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                showVerificationMessage =
                    false; // Hide the verification message
              });
              showSuccessMessage(); // Trigger the success message
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AspectRatios.width * 0.04307692307692307692307692307692,
        ),
        child: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SvgPicture.asset(
              'assets/logos/black_logo.svg',
              height: AspectRatios.height * 0.04747826086956521739130434782609,
              width: AspectRatios.width * 0.14871794871794871794871794871795,
            ),
            // Conditional Messages
            if (showVerificationMessage)
              GestureDetector(
                onTap: showVerificationDialog, // Show the dialog
                child: Container(
                  height:
                      AspectRatios.height * 0.03757575757575757575757575757576,
                  width:
                      AspectRatios.width * 0.91384615384615384615384615384615,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 158, 158, 158)
                        .withOpacity(0.2), // Light background color
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        size: AspectRatios.height *
                            0.02424242424242424242424242424242,
                      ),
                      SizedBox(width: AspectRatios.width * 0.01),
                      const Text(
                        "Please verify your email.",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (emailVerified)
              Center(
                child: Container(
                  height:
                      AspectRatios.height * 0.03757575757575757575757575757576,
                  width:
                      AspectRatios.width * 0.91384615384615384615384615384615,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(25, 76, 175, 80)
                        .withOpacity(0.1), // Light background color
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Email is verified successfully.",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 76, 175, 80),
                        ),
                      ),
                      SizedBox(width: AspectRatios.width * 0.01),
                      SvgPicture.asset(
                        'assets/icons/shield.svg',
                        height: AspectRatios.height *
                            0.02545454545454545454545454545455,
                        width: AspectRatios.width *
                            0.05384615384615384615384615384615,
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height:
                    AspectRatios.height * 0.02545454545454545454545454545455,
              ),
            // Categories Section
            buildCategoriesSection(),
            SizedBox(
              height: AspectRatios.height * 0.012,
            ),
            // Top Rated Title
            SizedBox(
              height: AspectRatios.height * 0.02777777777,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: const Text(
                      'Top Rated',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 202, 196, 208),
                            width: 1.0,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          )),
                      child: Center(
                        child: Text(
                          mainCurrentCategoryTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SvgPicture.asset(
                      'assets/icons/filter_icon.svg',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AspectRatios.height * 0.012,
            ),
            Column(
              children: [
                FinestSection(
                  title: 'Monthly Finest',
                  currentCategory: mfCurrentCategoryTitle,
                  items: const [
                    {'content': "assets/images/FireFly_Logo.png"},
                    {'content': "assets/images/_4chicks_logo.png"},
                    {'content': "assets/images/CloudShot_logo.png"},
                  ],
                  categoriess: categoriess,
                ),
                FinestSection(
                  title: 'Yearly Finest',
                  currentCategory: yfCurrentCategoryTitle,
                  items: const [
                    {'content': "assets/images/FireFly_Logo.png"},
                    {'content': "assets/images/_4chicks_logo.png"},
                    {'content': "assets/images/CloudShot_logo.png"},
                  ],
                  categoriess: categoriess,
                ),
                FinestSection(
                  title: 'Rating Experts',
                  currentCategory: reCurrentCategoryTitle,
                  items: const [
                    {'content': "assets/images/mhmd_adass.png"},
                    {'content': "assets/images/mhmd_adass.png"},
                    {'content': "assets/images/mhmd_adass.png"},
                  ],
                  categoriess: categoriess,
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  // Function to create the Categories Section
  Widget buildCategoriesSection() {
    const categories = [
      {'icon': 'assets/icons/serviceis_icon.svg'},
      {'icon': 'assets/icons/food_icon.svg'},
      {'icon': 'assets/icons/clothes_icon.svg'},
      {'icon': 'assets/icons/educations_icon.svg'},
      {'icon': 'assets/icons/cars_icon.svg'},
    ];

    return Center(
      child: Wrap(
        spacing: AspectRatios.width * 0.07363363363,
        runSpacing: AspectRatios.heightWithoutAppBar * 0.015,
        alignment: WrapAlignment.start,
        children: categories.map((category) {
          return SizedBox(
              width: AspectRatios.width * 0.14256410256,
              height: AspectRatios.heightWithoutAppBar * 0.066,
              child: Column(
                children: [
                  SizedBox(
                    width: AspectRatios.width * 0.10256410256,
                    height: AspectRatios.heightWithoutAppBar * 0.044,
                    child: Stack(
                      children: [
                        Container(
                          color: AppColors.iconBackground.withOpacity(0.15),
                          height: AspectRatios.height * 0.044,
                          width: AspectRatios.width * 0.10256410256,
                        ),
                        Center(
                          child: SvgPicture.asset(
                            category['icon'] as String,
                            width: AspectRatios.width * 0.08974358974,
                            height: AspectRatios.height * 0.044,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    categoriess[categories.indexOf(category)],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ));
        }).toList(),
      ),
    );
  }
}

class FinestSection extends StatefulWidget {
  final String title;
  String currentCategory;
  final List<Map<String, String>> items;
  final List<String> categoriess;

  FinestSection({
    super.key,
    required this.title,
    required this.currentCategory,
    required this.items,
    required this.categoriess,
  });

  @override
  State<FinestSection> createState() => _FinestSectionState();
}

class _FinestSectionState extends State<FinestSection> {
  late PageController pageController; // Local PageController for this section
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(); // Initialize the PageController
  }

  @override
  void dispose() {
    pageController.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AspectRatios.height * 0.18444444444,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.currentCategory,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 158, 158, 158),
                ),
              ),
            ],
          ),
          SizedBox(height: AspectRatios.height * 0.01),
          buildPodiumSection(
              items: widget.items), // Call the podium section here
          SizedBox(height: AspectRatios.height * 0.01),
          Center(
            child: SmoothPageIndicator(
              controller: pageController,
              count: widget.categoriess.length,
              effect: ExpandingDotsEffect(
                activeDotColor: const Color.fromARGB(255, 255, 196, 45),
                dotHeight: AspectRatios.height * 0.005,
                dotWidth: AspectRatios.height * 0.01,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build each podium section
  Widget buildPodiumSection({
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      height: AspectRatios.height * 0.13222222222,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color.fromARGB(255, 243, 198, 35),
            Color.fromARGB(255, 255, 166, 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.1, 1.0],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: PageView.builder(
        controller: pageController,
        itemCount: widget.categoriess.length,
        onPageChanged: (int page) {
          setState(() {
            currentPage = page;
            widget.currentCategory = widget.categoriess[page];
          });
        },
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildPodiumItemWithContainer(
                content: items[0]['content'],
                text: "2",
                height: AspectRatios.height * 0.055,
              ),
              SizedBox(width: AspectRatios.width * 0.1),
              buildPodiumItemWithContainer(
                content: items[1]['content'],
                text: "1",
                height: AspectRatios.height * 0.08,
              ),
              SizedBox(width: AspectRatios.width * 0.1),
              buildPodiumItemWithContainer(
                content: items[2]['content'],
                text: "3",
                height: AspectRatios.height * 0.035,
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to build each podium item
  Widget buildPodiumItemWithContainer({
    required dynamic content,
    required String text,
    required double height,
  }) {
    Widget contentWidget;

    contentWidget = Padding(
      padding: EdgeInsets.symmetric(
        vertical: AspectRatios.height * 0.005,
      ),
      child: CircleAvatar(
        radius: AspectRatios.height * 0.024,
        backgroundImage: AssetImage(content),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        contentWidget,
        Stack(
          children: [
            Container(
              height: height - AspectRatios.height * 0.01,
              width: AspectRatios.width * 0.12,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: double.parse(text) != 1
                  ? Align(
                      alignment: Alignment.bottomCenter -
                          Alignment(
                              0,
                              double.parse(text) == 2
                                  ? 0.4
                                  : double.parse(text) == 1
                                      ? 0.75
                                      : 0),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/Crown.svg'),
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        )
      ],
    );
  }
}

class PopupMenuItemBuilder {
  static PopupMenuItem<String> build({
    required String value,
  }) {
    return PopupMenuItem<String>(
      height: AspectRatios.height * 0.05,
      value: value,
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(221, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
 */

//adas code
/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import smooth page indicator

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> categoriess = [
    "Food",
    "Services",
    "Cloths",
    "Education",
    "Cars"
  ]; // Add categories
  String mainCurrentCategoryTitle = "Food";
  String mfCurrentCategoryTitle = "Food";
  String yfCurrentCategoryTitle = "Food";
  String reCurrentCategoryTitle = "Food";
  PageController pageController =
      PageController(); // Page controller for the swiping
  int currentPage = 0; // Current page for the indicator
  bool showVerificationMessage = true; // Controls the verification message
  bool emailVerified = false; // Controls the success message

  void showSuccessMessage() {
    setState(() {
      emailVerified = true; // Show the success message
    });

    // Automatically hide success message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        emailVerified = false; // Hide the success message
      });
    });
  }

  void showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Verify Email"),
        content: const Text("Are you sure you want to verify your email?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                showVerificationMessage =
                    false; // Hide the verification message
              });
              showSuccessMessage(); // Trigger the success message
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/logos/black_logo.svg',
          height: AspectRatios.height * 0.04747826086956521739130434782609,
          width: AspectRatios.width * 0.14871794871794871794871794871795,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Conditional Messages
            if (showVerificationMessage)
              GestureDetector(
                onTap: showVerificationDialog, // Show the dialog
                child: Container(
                  height:
                      AspectRatios.height * 0.03757575757575757575757575757576,
                  width:
                      AspectRatios.width * 0.91384615384615384615384615384615,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 158, 158, 158)
                        .withOpacity(0.2), // Light background color
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        size: AspectRatios.height *
                            0.02424242424242424242424242424242,
                      ),
                      SizedBox(width: AspectRatios.width * 0.01),
                      const Text(
                        "Please verify your email.",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (emailVerified)
              Center(
                child: Container(
                  height:
                      AspectRatios.height * 0.03757575757575757575757575757576,
                  width:
                      AspectRatios.width * 0.91384615384615384615384615384615,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(25, 76, 175, 80)
                        .withOpacity(0.1), // Light background color
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Email is verified successfully.",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 76, 175, 80),
                        ),
                      ),
                      SizedBox(width: AspectRatios.width * 0.01),
                      SvgPicture.asset(
                        'assets/icons/shield.svg',
                        height: AspectRatios.height *
                            0.02545454545454545454545454545455,
                        width: AspectRatios.width *
                            0.05384615384615384615384615384615,
                      ),
                    ],
                  ),
                ),
              ),
            // Categories Section
            buildCategoriesSection(),
            // Top Rated Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Rated',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 202, 196, 208),
                            width: 1.0,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          )),
                      child: Text(
                        mainCurrentCategoryTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed:
                            () {}, // Keep it empty since PopupMenuButton handles the tap
                        icon: PopupMenuButton<String>(
                          icon: const Icon(Icons.filter_list,
                              color: Color.fromARGB(221, 0, 0, 0)),
                          color: const Color.fromARGB(255, 255, 255,
                              255), // Background color of the popup menu
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          elevation: 4, // Slight shadow for depth
                          onSelected: (String value) {
                            setState(() {
                              mainCurrentCategoryTitle = value;
                              mfCurrentCategoryTitle = value;
                              yfCurrentCategoryTitle = value;
                              reCurrentCategoryTitle = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              categoriess.map((String category) {
                            return PopupMenuItemBuilder.build(value: category);
                          }).toList(),
                        )),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                FinestSection(
                  title: 'Monthly Finest',
                  currentCategory: mfCurrentCategoryTitle,
                  items: const [
                    {'content': "assets/images/FireFly_Logo.png"},
                    {'content': "assets/images/_4chicks_logo.png"},
                    {'content': "assets/images/CloudShot_logo.png"},
                  ],
                  categoriess: categoriess,
                ),
                FinestSection(
                  title: 'Yearly Finest',
                  currentCategory: yfCurrentCategoryTitle,
                  items: const [
                    {'content': "assets/images/FireFly_Logo.png"},
                    {'content': "assets/images/_4chicks_logo.png"},
                    {'content': "assets/images/CloudShot_logo.png"},
                  ],
                  categoriess: categoriess,
                ),
                FinestSection(
                  title: 'Rating Experts',
                  currentCategory: reCurrentCategoryTitle,
                  items: const [
                    {'content': "assets/images/mhmd_adass.png"},
                    {'content': "assets/images/mhmd_adass.png"},
                    {'content': "assets/images/mhmd_adass.png"},
                  ],
                  categoriess: categoriess,
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  // Function to create the Categories Section
  Widget buildCategoriesSection() {
    const categories = [
      {'icon': 'assets/icons/serviceis_icon.svg'},
      {'icon': 'assets/icons/food_icon.svg'},
      {'icon': 'assets/icons/clothes_icon.svg'},
      {'icon': 'assets/icons/educations_icon.svg'},
      {'icon': 'assets/icons/cars_icon.svg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AspectRatios.width * 0.05,
          runSpacing: AspectRatios.height * 0.02,
          alignment: WrapAlignment.start,
          children: categories.map((category) {
            return SizedBox(
              width: AspectRatios.width * 0.18,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: SvgPicture.asset(
                  category['icon'] as String,
                  height:
                      AspectRatios.height * 0.0594648166501486620416253716551,
                  width:
                      AspectRatios.width * 0.04360753221010901883052527254708,
                ),
                onPressed: () {},
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FinestSection extends StatefulWidget {
  final String title;
  String currentCategory;
  final List<Map<String, String>> items;
  final List<String> categoriess;

  FinestSection({
    super.key,
    required this.title,
    required this.currentCategory,
    required this.items,
    required this.categoriess,
  });

  @override
  State<FinestSection> createState() => _FinestSectionState();
}

class _FinestSectionState extends State<FinestSection> {
  late PageController pageController; // Local PageController for this section
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(); // Initialize the PageController
  }

  @override
  void dispose() {
    pageController.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.currentCategory,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 158, 158, 158),
              ),
            ),
          ],
        ),
        SizedBox(height: AspectRatios.height * 0.01),
        buildPodiumSection(items: widget.items), // Call the podium section here
        SizedBox(height: AspectRatios.height * 0.01),
        Center(
          child: SmoothPageIndicator(
            controller: pageController,
            count: widget.categoriess.length,
            effect: ExpandingDotsEffect(
              activeDotColor: const Color.fromARGB(255, 255, 196, 45),
              dotHeight: AspectRatios.height * 0.005,
              dotWidth: AspectRatios.height * 0.01,
            ),
          ),
        ),
      ],
    );
  }

  // Function to build each podium section
  Widget buildPodiumSection({
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      height: AspectRatios.height * 0.14424242424242424242424242424242,
      width: AspectRatios.width * 0.91384615384615384615384615384615,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color.fromARGB(255, 243, 198, 35),
            Color.fromARGB(255, 255, 166, 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.1, 1.0],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: PageView.builder(
        controller: pageController,
        itemCount: widget.categoriess.length,
        onPageChanged: (int page) {
          setState(() {
             currentPage = page;
            widget.currentCategory = widget.categoriess[page];
          });
        },
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildPodiumItemWithContainer(
                content: items[0]['content'],
                text: "2nd",
                height: AspectRatios.height * 0.057,
              ),
              SizedBox(width: AspectRatios.width * 0.1),
              buildPodiumItemWithContainer(
                content: items[1]['content'],
                text: "1st",
                height: AspectRatios.height * 0.08,
              ),
              SizedBox(width: AspectRatios.width * 0.1),
              buildPodiumItemWithContainer(
                content: items[2]['content'],
                text: "3rd",
                height: AspectRatios.height * 0.035,
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to build each podium item
  Widget buildPodiumItemWithContainer({
    required dynamic content,
    required String text,
    required double height,
  }) {
    Widget contentWidget;

    contentWidget = CircleAvatar(
      radius: AspectRatios.height * 0.028,
      backgroundImage: AssetImage(content),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        contentWidget,
        SizedBox(height: AspectRatios.height * 0.0039),
        Container(
          height: height,
          width: AspectRatios.width * 0.15,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (text == "1st")
                  SvgPicture.asset(
                    'assets/icons/Crown.svg',
                    height: AspectRatios.height * 0.033,
                  ),
                Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ]
          ),
        ),)
      ],
    );
  }
}

class PopupMenuItemBuilder {
  static PopupMenuItem<String> build({
    required String value,
  }) {
    return PopupMenuItem<String>(
      height: AspectRatios.height * 0.05,
      value: value,
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(221, 0, 0, 0),
          ),
        ),
      ),
    );
  }
} */
