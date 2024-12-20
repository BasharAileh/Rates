import 'package:flutter/material.dart';

class view_rating extends StatefulWidget {
  const view_rating({super.key});

  @override
  State<view_rating> createState() => _view_ratingState();
}

class _view_ratingState extends State<view_rating> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text("Menu", style: TextStyle(color: Colors.black)),
        actions: const [
          Icon(Icons.filter_alt_outlined, color: Colors.black),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Restaurant Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/testpic/babalyamen.jpg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Bab el-yamen',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: toggleFavorite,
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            'Rating of ',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            '3.5 stars',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Food Item Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/images/testpic/raizmalee.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mandi Meal',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Half chicken, rice, 2 spicy sauces',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Rate'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Review Section
          Expanded(
            child: ListView(
              children: const [
                ReviewTile(
                  user: 'User 1',
                  review: 'The rice was cold, not spicy enough',
                  rating: 2,
                ),
                ReviewTile(
                  user: 'User 2',
                  review: 'took too long to get ready!',
                  rating: 3,
                ),
                ReviewTile(
                  user: 'User 3',
                  review: 'average',
                  rating: 3,
                ),
                ReviewTile(
                  user: 'User 4',
                  review: 'loved it!',
                  rating: 5,
                ),
                ReviewTile(
                  user: 'User 5',
                  review: 'tasty',
                  rating: 4,
                ),
                ReviewTile(
                  user: 'User 6',
                  review: 'eat in restaurant, it\'s a lot better and tasty',
                  rating: 4,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Rate'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final String user;
  final String review;
  final int rating;

  const ReviewTile(
      {super.key,
      required this.user,
      required this.review,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Text(user[0]),
      ),
      title: Text(review),
      subtitle: Row(
        children: List.generate(
          5,
          (index) => Icon(
            Icons.star,
            color: index < rating ? Colors.yellow : Colors.grey,
            size: 16,
          ),
        ),
      ),
    );
  }
}
