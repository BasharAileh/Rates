import 'package:flutter/material.dart';
import 'dart:ui'; // Import this to use BackdropFilter

// ignore: must_be_immutable
class AlertPages extends StatelessWidget {
  GlobalKey<ScaffoldState> sk = GlobalKey();

  AlertPages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: alertpage(context), // Call the alertpage method here
    );
  }

  ListView alertpage(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: MaterialButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return Dialog(
                    // Use Dialog instead of AlertDialog for customization
                    backgroundColor: Colors.transparent, // Make background transparent
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5), // Blur effect
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(138, 165, 232, 0.941), // Background color for dialog
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20), // Add padding
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Size based on content
                          children: [
                            const Text("There is something wrong",
                                style: TextStyle(color: Colors.black, fontSize: 20)),
                            const SizedBox(height: 10), // Space between title and content
                            const Text("The app doesn't respond",
                                style: TextStyle(color: Colors.white, fontSize: 15)),
                            const SizedBox(height: 20), // Space before actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Logic to close the app can go here
                                  },
                                  child: const Text(
                                    "Close App",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text("Wait",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            color: const Color.fromRGBO(241, 159, 194, 1),
            height: 50,
            child: const Text("Show Alert"), // Adjust height for better visibility
          ),
        )
      ],
    );
  }
}
