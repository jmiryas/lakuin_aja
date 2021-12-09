import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";

import '../data/constant_data.dart';
import '../screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppTitle,
      home: HomeScreen(),
    );
  }
}
