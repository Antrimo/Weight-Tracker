import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weight/Screens/splash.dart';
import 'package:weight/Screens/Theme/theme.dart';

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

































// import 'package:flutter/material.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:weight/Services/home_page.dart';
// import 'package:weight/Services/notifi_service.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   NotificationService().initNotification();
//   tz.initializeTimeZones();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Notifications',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Local Notifications'),
//     );
//   }
// }