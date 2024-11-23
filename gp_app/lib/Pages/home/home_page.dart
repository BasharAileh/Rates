import 'package:flutter/material.dart';
import 'package:rates/dialogs/nav_bar.dart';

int pageIndex = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
