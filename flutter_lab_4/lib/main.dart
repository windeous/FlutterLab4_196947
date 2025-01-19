import 'package:flutter/material.dart';
import 'package:flutter_lab_4/models/exam.dart';
import 'package:flutter_lab_4/views/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(
      'America/Los_Angeles')); 

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final exams = Exam.getAllExams();


    return MaterialApp(
      title: 'Exam Map App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(exams: exams),
    );
  }
}