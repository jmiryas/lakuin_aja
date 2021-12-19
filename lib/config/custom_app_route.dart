import 'package:flutter/material.dart';

class CustomAppRoute {
  // * Routes:

  static const String homeScreen = "/";
  static const String todoScreen = "/todo";
  static const String errorScreen = "/error";
  static const String goalsScreen = "/goals";
  static const String signInScreen = "/signIn";
  static const String targetScreen = "/target";
  static const String addTodoScreen = "/add-todo";
  static const String targetDetailsScreen = "/target-details";

  // * Go to route:

  static Route goToRoute(dynamic screen, String routeName) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (context) => screen);
  }
}
