import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Tracker'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}