import 'package:admin/constants/app_colors.dart';
import 'package:admin/constants/aspect_ratio.dart';
import 'package:flutter/material.dart';

class AdminRestaurantsPage extends StatefulWidget {
  const AdminRestaurantsPage({super.key});

  @override
  _AdminRestaurantsPageState createState() => _AdminRestaurantsPageState();
}

class _AdminRestaurantsPageState extends State<AdminRestaurantsPage> {
  final List<Map<String, String>> restaurants = [
    {
      'name': 'Bab el-Yamen1',
      'image': 'asstes/babalyamen.jpg',
      'status': 'Pending'
    },
    {
      'name': 'Bab el-Yamen2',
      'image': 'asstes/babalyamen.jpg',
      'status': 'Pending'
    },{
      'name': 'Bab el-Yamen1',
      'image': 'asstes/babalyamen.jpg',
      'status': 'Pending'
    },{
      'name': 'Bab el-Yamen1',
      'image': 'asstes/babalyamen.jpg',
      'status': 'Pending'
    },{
      'name': 'Bab el-Yamen1',
      'image': 'asstes/babalyamen.jpg',
      'status': 'Pending'
    },
  ];

  void _showDecisionDialog(BuildContext context, int index) {
    final restaurant = restaurants[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Action Required'),
          content: Text('Do you want to accept or decline ${restaurant['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  restaurants.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${restaurant['name']} has been accepted.')),
                );
              },
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  restaurants.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${restaurant['name']} has been declined.')),
                );
              },
              child: Text('Decline'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Restaurant Information",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: restaurants.isEmpty
          ? Center(
              child: Text(
                'No Pending Restaurants',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.asset(
                              restaurant['image']!,
                              height: AspectRatios.height*0.17,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant['name']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Status: ${restaurant['status']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                _showDecisionDialog(context, index);
                              },
                              child: Text(
                                'Pending',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
