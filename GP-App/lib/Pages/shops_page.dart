import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  final List<Map<String, String>> restaurants = [
    {
      "name": "Calma Space",
      "logo": "assets/images/R.png",
    },
    {
      "name": "Hattan Cafe",
      "logo": "assets/images/R.png",
    },
    {
      "name": "Hattan Cafe",
      "logo": "assets/images/R.png",
    },
    {
      "name": "Hattan Cafe",
      "logo": "assets/images/R.png",
    },
    {
      "name": "Hattan Cafe",
      "logo": "assets/images/R.png",
    },
    {
      "name": "Hattan Cafe",
      "logo": "assets/images/R.png",
    },
    {
      "name": "Hattan Cafe",
      "logo": "assets/images/R.png",
    },
    {
      "name": "Hattan Cafe",
      "logo": "assets/images/R.png",
    },

    // Add more restaurants as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Shops Page',
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(shopRoute);
            },
            child: RestaurantCard(
              name: restaurants[index]['name']!,
              logo: restaurants[index]['logo']!,
            ),
          );
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String name;
  final String logo;

  const RestaurantCard({super.key, required this.name, required this.logo});

  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(AspectRatios.width * 0.05,
          AspectRatios.height * 0.0415, AspectRatios.width * 0.05, 0),
      child: Container(
        height: totalHeight * 0.17,
        width: totalWidth * 0.9, // Use a more reasonable width

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.amber,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: totalWidth * 0.05),
              //,
              child: Image.asset(
                logo,
                width: totalWidth * 0.19,
                height: totalHeight * 0.1,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text(
                name,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Rate",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
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
