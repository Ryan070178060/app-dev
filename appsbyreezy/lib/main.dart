import 'package:appsbyreezy/AllScreens/mainscreen.dart';
import 'package:appsbyreezy/AllScreens/start_screen.dart';
import 'package:appsbyreezy/splashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reezy Taxi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
