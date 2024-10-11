import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weight/Screens/first.dart';
class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstRunScreen()));
        },
        child: Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: Lottie.asset('assets/health.json'),
        ),
      ),
    );
  }
}