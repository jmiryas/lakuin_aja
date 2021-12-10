import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/target_screen.dart';
import '../screens/error_screen.dart';
import '../screens/sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          } else if (snapshot.hasData) {
            return const TargetScreen();
          } else if (snapshot.hasError) {
            return const ErrorScreen();
          } else {
            return const SignInScreen();
          }
        });
  }
}
