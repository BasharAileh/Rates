// import 'package:flutter/material.dart';
// //import 'package:rates/Pages/rating_page.dart';

// /// A function to display the rating dialog.
// /// Pass the context to show the dialog.
// Future<void> showRatingDialog(BuildContext context) async {
//   final TextEditingController codeController = TextEditingController();

//   // Function to simulate fetching meals based on the entered code
//   Future<List<Map<String, String>>> fetchMealsForCode(String code) async {
//     // Meal data for each valid code
//     const mealsData = {
//       'VALID1': [
//         {'name': 'Shawarma', 'image': 'assets/images/BurgarMaker_Logo.jpeg'},
//       ],
//       'VALID2': [
//         {'name': 'Shawarma', 'image': 'assets/images/meals/shawerma_meal.jpg'},
//         {'name': 'Burger', 'image': 'assets/images/meals/Burger-meal.jpg'},
//       ],
//       'VALID3': [
//         {'name': 'Shawarma', 'image': 'assets/images/BurgarMaker_Logo.jpeg'},
//         {'name': 'Burger', 'image': 'assets/images/BurgarMaker_Logo.jpeg'},
//         {'name': 'Noodles', 'image': 'assets/images/BurgarMaker_Logo.jpeg'},
//       ],
//     };

//     // Return the meals based on the code, or throw an error for invalid code
//     if (mealsData.containsKey(code)) {
//       return mealsData[code]!;
//     } else {
//       throw Exception('Invalid code');
//     }
//   }

//   return showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Enter Rating Code'),
//       content: TextField(
//         controller: codeController,
//         decoration: const InputDecoration(hintText: 'Enter receipt number'),
//         keyboardType: TextInputType.text,
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close dialog
//           },
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () async {
//             String code = codeController.text.trim();
//             try {
//               // Fetch meals based on the entered code
//               List<Map<String, String>> meals = await fetchMealsForCode(code);

//               // Close dialog and navigate to the RatingPage with meals
//               Navigator.of(context).pop();
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => RatingPage(meals: meals,restaurantName:'Rating',restaurantLogo:'assets/images/BurgarMaker_Logo.jpeg'),
//                 ),
//               );
//             } catch (e) {
//               // Show error message for invalid code
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Invalid code. Please try again.'),
//                 ),
//               );
//             }
//           },
//           child: const Text('Submit'),
//         ),
//       ],
//     ),
//   );
// }
