import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/constants/app_colors.dart';


/// Text style for profile details in the Drawer header.
const TextStyle profileTextStyle = TextStyle(
  color: AppColors.textColor,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

/// Navigation Drawer for the application.
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Set drawer width to 60% of the screen width for a responsive layout
      width: AspectRatios.width * 0.6,
      child: ListView(
        children: [
          // User Account Header with profile information
          const UserAccountsDrawerHeader(
            accountName: Text(
              'mhmd adass',
              style: profileTextStyle,
            ),
            accountEmail: Text(
              'mohammadaladass63@gmail.com',
              style: profileTextStyle,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/mhmd_adass.png'),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 33, 150, 243),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/Vertical_background.png'),
              ),
            ),
          ),

          // Drawer Menu Items
          buildListTile(
            context: context,
            icon: Icons.favorite,
            title: 'Favorites',
            onTap: () => Navigator.of(context).pushNamed(favoriteRoute),
          ),
          buildListTile(
            context: context,
            icon: Icons.person,
            title: 'Profile',
            onTap: () => showDevelopmentSnackBar(context),
          ),
          const Divider(color: Color.fromARGB(255, 0, 0, 0)), 


          buildListTile(
            context: context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => showDevelopmentSnackBar(context),
          ),
          buildListTile(
            context: context,
            icon: Icons.help,
            title: 'Help',
            onTap: () => showDevelopmentSnackBar(context),
          ),
          buildListTile(
            context: context,
            icon: Icons.description,
            title: 'Policies',
            onTap: () => showDevelopmentSnackBar(context),
          ),
          const Divider(color: Color.fromARGB(255, 0, 0, 0)),

          buildListTile(
            context: context,
            icon: Icons.exit_to_app,
            title: 'Log out',
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamed(loginRoute);
            },
          ),
        ],
      ),
    );
  }

  // Creates a ListTile widget for items in the Drawer.
  Widget buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  // Displays a SnackBar indicating the section is under development.
  void showDevelopmentSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This section is under development')),
    );
  }
}
