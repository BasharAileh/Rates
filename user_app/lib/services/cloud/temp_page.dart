import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key});

  @override
  State<RatingsPage> createState() => RratingsStatePage();
}

late TextEditingController ratingController;

class RratingsStatePage extends State<RatingsPage> {
  @override
  void initState() {
    super.initState();
    ratingController = TextEditingController();
  }

  @override
  void dispose() {
    ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseCloudStorage cloudService = FirebaseCloudStorage();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ratings'),
      ),
      body: Column(
        children: [
          TextField(
            controller: ratingController,
            decoration: const InputDecoration(
              hintText: 'Enter your rating',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              cloudService.insertDocument(
                'product_rating',
                {
                  'product_id': 'test_sha',
                  'product_category_id': 'shawarma',
                  'rating_value': double.parse(ratingController.text),
                },
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
