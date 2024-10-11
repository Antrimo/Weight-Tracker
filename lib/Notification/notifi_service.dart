import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:lottie/lottie.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

int id = 0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalTimeZone();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
      selectNotificationStream.add(notificationResponse.payload);
    },
  );
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final bool? granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = granted ?? false;
      });
    }
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Lottie.asset('assets/notification.json'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Show Notification'),
              onTap: () async {
                await _showNotification();
                Navigator.pop(context);  
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Schedule Notification'),
              onTap: () async {
                await _scheduleNotification();
                Navigator.pop(context);  
              },
            ),
          ],
        ),
    );
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      id++,
      'Weight Tracker',
      'You have not logged your weight today',
      notificationDetails,
    );
  }

  Future<void> _scheduleNotification() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      DateTime now = DateTime.now();

      DateTime scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      if (scheduledDateTime.isBefore(now)) {
        scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id++,
        'Scheduled Title',
        'Scheduled Body',
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
