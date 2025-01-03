import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/dialogs/redeem_dialog.dart';

class ViewRating extends StatefulWidget {
  const ViewRating({
    super.key,
    required this.restaurantName,
    required this.rating,
    required this.mealName,
    required this.imagePath,
  });

  final String restaurantName;
  final double rating;
  final String mealName;
  final String imagePath;
  @override
  State<ViewRating> createState() => _ViewRatingState();
}

class _ViewRatingState extends State<ViewRating> {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Info Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AspectRatios.width * 0.12,
                  height: AspectRatios.height * 0.055,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/testpic/babalyamen.jpg'),
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
                        'Rating of ${widget.rating.toStringAsFixed(1)} stars',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.black),
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
              child: Image.asset(
                widget.imagePath,
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
                    Text(
                      widget.mealName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    backgroundColor: const Color.fromARGB(255, 243, 198, 35),
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
      ),
    );
  }
}
