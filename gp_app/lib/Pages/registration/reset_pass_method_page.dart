import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';

class ResetPassMethodPage extends StatefulWidget {
  const ResetPassMethodPage({super.key});

  @override
  State<ResetPassMethodPage> createState() => _ResetPassMethodPageState();
}

class _ResetPassMethodPageState extends State<ResetPassMethodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Method'),
        centerTitle: true,
      ),
      body: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: AspectRatios.heightWithoutAppBar * 0.32523696682,
            left: AspectRatios.width * 0.12179487179,
            right: AspectRatios.width * 0.12179487179,
          ),
          child: const Center(
            child: Text('aaaaaaaaaaaaaaaaaaaaaaaa'),
          ),
        ),
      ),
    );
  }
}
