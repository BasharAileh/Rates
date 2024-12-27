import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rates/Pages/shop/menu_page.dart';

class view_rating extends StatefulWidget {
  const view_rating({super.key});

  @override
  State<view_rating> createState() => _view_ratingState();
}

class _view_ratingState extends State<view_rating> {
  bool isFavorite = false;
  bool _isVisible = true;
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> reviews = [
    {'user': 'User 1', 'review': 'The rice was cold, not spicy enough', 'rating': 2, 'avatar': 'assets/images/avatar1.png'},
    {'user': 'User 2', 'review': 'took too long to get ready!', 'rating': 3, 'avatar': 'assets/images/avatar2.png'},
    {'user': 'User 3', 'review': 'average', 'rating': 3, 'avatar': 'assets/images/avatar3.png'},
    {'user': 'User 4', 'review': 'loved it!', 'rating': 5, 'avatar': 'assets/images/avatar4.png'},
    {'user': 'User 5', 'review': 'tasty', 'rating': 4, 'avatar': 'assets/images/avatar5.png'},
    {'user': 'User 6', 'review': 'eat in restaurant, it\'s a lot better and tasty', 'rating': 4, 'avatar': 'assets/images/avatar6.png'},
  ];

  @override
  void initState() {
  super.initState();
  _scrollController.addListener(() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  });
}
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void addReview(String user, String review, int rating, String avatar) {
    setState(() {
      reviews.add({'user': user, 'review': review, 'rating': rating, 'avatar': avatar});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MenuPage()),
            );
          },
        ),
        title: const Center(child: Text("Ratings", style: TextStyle(color: Colors.black))),
        actions: const [
          Icon(Icons.filter_alt_outlined, color: Colors.black),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            opacity: _isVisible ? 1.0 : 0.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: _isVisible ? null : 0.0,
              child: Column(
                children: [
                  // Restaurant Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/babalyamen.jpg', // Replace with actual logo URL
                            width: screenWidth * 0.15, // Adjust width based on screen width
                            height: screenHeight * 0.09, // Adjust height based on screen height
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Bab el-yamen',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
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
                            'assets/images/testpic/raizmalee.jpg', // Replace with actual image URL
                            height: screenHeight * 0.21, // Adjust height based on screen height
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mandi Meal',
                                  style: TextStyle(fontSize: screenHeight * 0.03, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Half chicken, rice, 2 spicy sauces',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF3C623),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Rate', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Review Section
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ReviewTile(
                  review: reviews[index]['review'],
                  rating: reviews[index]['rating'],
                  avatar: reviews[index]['avatar'],
                );
              },
            ),
          ),
        ],
      ),
    
    );
  }
}

class ReviewTile extends StatelessWidget {
  final String review;
  final int rating;
  final String avatar;

  const ReviewTile({super.key, required this.review, required this.rating, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(avatar),
              radius: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => SvgPicture.asset(
                        'assets/icons/star.svg',
                        color: index < rating ?const Color(0xFFF3C623) : Colors.grey,
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}