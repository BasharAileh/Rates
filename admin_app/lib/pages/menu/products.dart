import 'dart:io';
import 'package:admin_app/constants/app_colors.dart';
import 'package:admin_app/constants/aspect_ratio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  const ProductPage(
      {super.key,
      required this.restaurantName,
      required this.rating,
      required this.restaurantImage});

  final String restaurantName;
  final String restaurantImage;
  final double rating;

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  String searchQuery = "";
  List<Map<String, dynamic>> meals = [];
  final ImagePicker _picker = ImagePicker();
  
  Future<void> addMeal({Map<String, dynamic>? existingMeal}) async {
    String? mealName = existingMeal?["name"];
    String? mealDesc = existingMeal?["desc"];
    String? mealPrice = existingMeal?["price"];
    XFile? image = existingMeal != null
        ? XFile(existingMeal["image"])
        : null;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
          ),
          child: Container(
            width: AspectRatios.width * 0.8,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Center(
                  child: Text(
                      existingMeal == null ? "Add Meal" : "Edit Meal",
                      style: const TextStyle(fontSize: 20))),
                TextFormField(
                  initialValue: mealName,
                  decoration: const InputDecoration(
                    labelText: "Meal Name",
                    floatingLabelStyle: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                    enabledBorder: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    mealName = value;
                  },
                ),
                SizedBox(height: AspectRatios.height * 0.01),
                TextFormField(
                  initialValue: mealDesc,
                  decoration: const InputDecoration(
                    labelText: "Meal Description",
                    floatingLabelStyle: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                    enabledBorder: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    mealDesc = value;
                  },
                ),
                SizedBox(height: AspectRatios.height * 0.01),
                TextFormField(
                  initialValue: mealPrice,
                  decoration: const InputDecoration(
                    labelText: "Meal Price in JD",
                    floatingLabelStyle: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                    enabledBorder: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    mealPrice = value;
                  },
                ),
                SizedBox(height: AspectRatios.height * 0.01),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () async {
                    image = await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {});
                  },
                  child: Text(
                    image == null
                        ? 'Upload Meal Image'
                        : 'Change Meal Image',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                 Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (mealName != null && image != null) {
                      if (existingMeal != null) {
                        // Update existing meal
                        existingMeal["name"] = mealName;
                        existingMeal["desc"] = mealDesc;
                        existingMeal["price"] = mealPrice;
                        existingMeal["image"] = image!.path;
                      } else {
                        // Add new meal
                        meals.add({
                          "name": mealName!,
                          "desc": mealDesc,
                          "price": mealPrice,
                          "image": image!.path
                        });
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
         
              ],
            ),
          ),
          
           
        );
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
                SizedBox(width: AspectRatios.width * 0.02),
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
                          vertical: 5.0, horizontal: 15.0),
                    ),
                    style: TextStyle(fontSize: AspectRatios.width * 0.035),
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
                Container(
                  width: AspectRatios.width * 0.12,
                  height: AspectRatios.height * 0.055,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(widget.restaurantImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: AspectRatios.width * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurantName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rating of ${widget.rating}',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AspectRatios.height * 0.02),
            Column(
              children: [
                ...meals.map((meal) {
                  return MealCard(
                    mealName: meal["name"],
                    mealImage: meal["image"],
                    onDelete: () {
                      setState(() {
                        meals.remove(meal);
                      });
                    },
                    onEdit: () {
                      addMeal(existingMeal: meal);
                    },
                  );
                }),
                GestureDetector(
                  onTap: addMeal,
                  child: Container(
                    height: AspectRatios.height * 0.16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline,
                              size: 40, color: Colors.black),
                          SizedBox(height: AspectRatios.height * 0.01),
                          const Text("Add your meal",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.mealName,
    required this.mealImage,
    required this.onDelete,
    required this.onEdit,
  });

  final String mealName;
  final String mealImage;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: AspectRatios.height * 0.16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            image: DecorationImage(
              image: FileImage(File(mealImage)),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -5,
                right: -5,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
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
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => ViewRating(
                          //             restaurantName: restaurant.name,
                          //             rating: restaurant.rating,
                          //             mealName: menuItem["name"]!,
                          //             imagePath: menuItem["image"]!,
                          //           )),
                          // );
                        },
                        // Transparent black background
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mealName,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return const VerificationDialogPage(); // Show the verification dialog
                            //   },
                            // );
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AspectRatios.height * 0.02),
      ],
    );
  }
}
