import 'package:flutter/material.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height * 0.05;
/* final totalFlex = 1*restaurants.length; */
/* final height = totalHeight * (1 / totalFlex); */
    final totalwidth = MediaQuery.of(context).size.width * 0.02;
    final width = totalHeight * (1 / totalwidth);
    return MaterialApp(
      home: RestaurantListScreen(),
    );
  }
}

class RestaurantListScreen extends StatelessWidget {
  final List<Map<String, String>> restaurants = [
    {
      "name": "calma space ",
      "logo": "images/R.jpg",
    },
    {
      "name": "Hattan cafe",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
    {
      "name": "2K study house",
      "logo": "images/R.jpg",
    },
  ];

  RestaurantListScreen({super.key});

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
          'shops page',
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return RestaurantCard(
            name: restaurants[index]['name']!,
            logo: restaurants[index]['logo']!,
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
/* final totalFlex = 1*restaurants.length; */
/* final height = totalHeight * (1 / totalFlex); */
    final totalwidth = MediaQuery.of(context).size.width;
    final width = totalHeight * (1 / totalwidth);
    return Container(
      height: totalHeight * 0.17,
      width: totalwidth * 0.17,
      margin: EdgeInsets.only(
          bottom: 0,
          top: totalHeight * 0.045,
          left: totalwidth * 0.05,
          right: totalwidth * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.amber,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: totalwidth * 0.05),
            child: Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: Colors.green),
                child: Image.asset(
                  logo,
                  width: totalwidth * 0.19,
                  height: totalHeight * 0.1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
            height: 5,
          ),
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("rate",style: TextStyle(fontSize: 16),),
                IconButton(
                  style: ButtonStyle(),
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
