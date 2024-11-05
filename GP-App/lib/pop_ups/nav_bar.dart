import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
 pages/login-register
      width: AspectRatios.width * 0.6,

      backgroundColor: Colors.grey[850],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
pages/login-register
            accountName: const Text('mhmd adass',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            accountEmail: const Text('mohammadaladass63@gmail.com',
                style: TextStyle(fontSize: 14)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/path_to_your_image.png',
                  fit: BoxFit.cover,
                  width: AspectRatios.width * 1,
                  height: AspectRatios.height * 1,

                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.fill,
 pages/login-register
                image: AssetImage('assets/path_to_background_image.png'),
              ),
            ),
          ),
          _buildListTile(Icons.favorite, 'Favorites', () {}),

          _buildListTile(Icons.person, 'Profile', () {
            // Add your Profile navigation logic here
          }),
          const Divider(),
          _buildListTile(Icons.settings, 'Settings', () {
            // Add your Settings navigation logic here
          }),
          _buildListTile(Icons.help, 'Help', () {
            // Add your Help navigation logic here
          }),
          _buildListTile(Icons.description, 'Policies', () {
            // Add your Policies navigation logic here
          }),
          const Divider(),
          _buildListTile(Icons.exit_to_app, 'Log out', () {
            FirebaseAuth.instance.signOut();
ages/login-register
            Navigator.of(context).pushNamed(loginRoute);

          }),
        ],
      ),
    );
  }

  ListTile _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
pages/login-register
      leading: Icon(icon, size: 28, color: Colors.amber),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

    );
  }
}
