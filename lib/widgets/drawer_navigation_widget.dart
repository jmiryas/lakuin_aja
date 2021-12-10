import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/constant_data.dart';
import '../config/custom_app_route.dart';
import '../widgets/about_us_widget.dart';
import '../providers/google_sign_in_provider.dart';

class DrawerNavigationWidget extends StatelessWidget {
  const DrawerNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("images/wallpaper.png"),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(2.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: const Text(
                  kAppTitle,
                  style: TextStyle(
                    fontSize: 25.0,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            title: Text(user.displayName!),
            subtitle: Text(user.email!),
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Log Out?"),
                      content: const Text("Keluar dari aplikasi?"),
                      actions: [
                        TextButton(
                          child: const Text("Tidak"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text("Iya"),
                          onPressed: () async {
                            final googleSignInProvider =
                                Provider.of<GoogleSignInProvider>(context,
                                    listen: false);

                            await googleSignInProvider.googleLogout();

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(
                  Icons.event_note,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Goals",
                )
              ],
            ),
            onTap: () =>
                Navigator.pushNamed(context, CustomAppRoute.goalsScreen),
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(
                  Icons.info,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Tentang Kami",
                )
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AboutUsWidget();
                  });
            },
          )
        ],
      ),
    );
  }
}
