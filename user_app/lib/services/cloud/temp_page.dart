import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rates/constants/aspect_ratio.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.white, // Customize the color
       elevation: 0, 
       scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
                    'assets/logos/black_logo.svg',
                    height: AspectRatios.height * 0.14333333333,
                    width: AspectRatios.width * 0.14871794871,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
            const SizedBox(height: 20),

            

            // Mission Section
            _buildSection(
              title: 'Our Mission',
              content:
                  'At Rates, we strive to provide a trustworthy platform where genuine feedback takes center stage. Our mission is to eliminate fake reviews and empower users with authentic and transparent ratings. By promoting integrity and fairness, we aim to help people make confident, well-informed decisions.',
              isDarkTheme: isDarkTheme,
            ),
            const SizedBox(height: 20),

            // What We Do Section
            _buildSection(
              title: 'What We Do',
              content:
                  'We focus on delivering accurate and unbiased ratings for products and services by filtering out fake and misleading reviews. Our platform leverages advanced verification processes to ensure that every rating reflects real user experiences. By prioritizing authenticity, we help users discover the true value of items and make decisions they can trust.',
              isDarkTheme: isDarkTheme,
            ),
            const SizedBox(height: 20),

            // Why Choose Us Section
            _buildSection(
              title: 'Why Choose Us?',
              content:
                  '- **Authenticity** Guaranteed: We are committed to providing genuine and verified ratings, free from fake reviews..\n'
                  '- **Transparency** You Can Trust: Our platform ensures unbiased and reliable insights for every product or service..\n'
                  '- **User-Centered** Experience: We prioritize your confidence by offering a straightforward, trustworthy, and effective rating system.\n'
                  '- **Empowering** Decisions: With accurate data at your fingertips, you can make well-informed choices with ease.',
              isDarkTheme: isDarkTheme,
            ),
            const SizedBox(height: 20),

            // Team Section
           _buildSection(
  title: 'Meet the Team',
  content: '''
At Rates, our team is driven by a shared mission to provide authentic, transparent, and reliable ratings for everyone. Each member brings unique expertise, passion, and dedication to making the Rates app a trusted platform.

* Bashar Akileh – Team Lead  
Bashar leads the team with vision and determination, ensuring every aspect of the project aligns with our mission of promoting genuine ratings.

* Braa Shaban  
Braa brings innovation and creativity to the team, contributing to the app’s development and design.

* Hamza Shakhatreh  
Hamza is dedicated to enhancing user experience and ensuring the platform meets the highest standards of authenticity.

* Mohammad Al-Adass 
Mohammad’s expertise in data analysis plays a vital role in filtering out fake reviews and verifying accurate ratings.

* Hasan Beidas  
Hasan focuses on delivering technical excellence, helping to build a robust and reliable platform.

* Sharaf Bassam 
Sharaf supports the team with insights and solutions that drive the app’s success and user satisfaction.

Together, we are committed to creating a platform that empowers users to make confident and informed decisions, free from the influence of fake reviews.
''',
  isDarkTheme: isDarkTheme,
),

            const SizedBox(height: 20),

            // Call to Action
            ElevatedButton(
              onPressed: () {
                // Add navigation or action here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your support!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkTheme ? const Color(0xFFF3C623) : Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Join Us Today'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build sections
  Widget _buildSection({
    required String title,
    required String content,
    required bool isDarkTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? const Color(0xFFF3C623) : Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color:isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}

