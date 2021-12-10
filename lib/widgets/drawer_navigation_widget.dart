import 'package:flutter/material.dart';

import '../data/constant_data.dart';
import '../config/custom_app_route.dart';
import '../widgets/about_us_widget.dart';

class DrawerNavigationWidget extends StatelessWidget {
  const DrawerNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
