import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/constant_data.dart';
import '../providers/google_sign_in_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    width: 50.0,
                    height: 50.0,
                    image: AssetImage(kAppIcon),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: const Text(
                      kAppTitle,
                      style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 1.3,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Sebuah aplikasi untuk menulis target-target harian.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 1.2,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final googleSignInProvider =
                        Provider.of<GoogleSignInProvider>(context,
                            listen: false);

                    await googleSignInProvider.googleLogin();
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                  ),
                  label: const Text("Sign In with Google"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
