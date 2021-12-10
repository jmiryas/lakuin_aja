import 'package:flutter/material.dart';
import 'package:lakuin_aja/widgets/drawer_navigation_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/google_sign_in_provider.dart';

class TargetScreen extends StatelessWidget {
  const TargetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Target"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final googleSignInProvider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);

              googleSignInProvider.googleLogout();
            },
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: const DrawerNavigationWidget(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(user!.uid),
            Text(user.displayName!),
            Text(user.email!),
          ],
        ),
      ),
    );
  }
}
