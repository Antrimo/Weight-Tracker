import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weight/Screens/splash.dart';
import 'package:weight/Theme/theme.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox('Habit_Database');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkMode,
      themeMode: ThemeMode.dark,
      home: const Splash(),
    );
  }
}



