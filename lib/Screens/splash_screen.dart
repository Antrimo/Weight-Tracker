import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weight/Screens/intro_screen.dart';
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
          color: const Color.fromARGB(255, 36, 83, 38),
          alignment: Alignment.center,
          child: Lottie.asset('assets/health.json'),
        ),
      ),
    );
  }
}