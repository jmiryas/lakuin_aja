import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:firebase_core/firebase_core.dart";

import '../config/app_router.dart';
import '../data/constant_data.dart';
import '../config/custom_app_route.dart';
import '../providers/google_sign_in_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: kAppTitle,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: CustomAppRoute.homeScreen,
      ),
    );
  }
}
