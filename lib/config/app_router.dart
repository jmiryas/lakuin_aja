import 'package:flutter/material.dart';
import 'package:lakuin_aja/models/target_model.dart';
import 'package:lakuin_aja/screens/target_details_screen.dart';

import '../screens/home_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/error_screen.dart';
import '../screens/target_screen.dart';
import '../screens/sign_in_screen.dart';
import '../config/custom_app_route.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CustomAppRoute.homeScreen:
        return CustomAppRoute.goToRoute(
            const HomeScreen(), CustomAppRoute.homeScreen);
      case CustomAppRoute.signInScreen:
        return CustomAppRoute.goToRoute(
            const SignInScreen(), CustomAppRoute.signInScreen);
      case CustomAppRoute.targetScreen:
        return CustomAppRoute.goToRoute(
            const TargetScreen(), CustomAppRoute.targetScreen);
      case CustomAppRoute.goalsScreen:
        return CustomAppRoute.goToRoute(
            const GoalsScreen(), CustomAppRoute.goalsScreen);
      case CustomAppRoute.targetDetailsScreen:
        return CustomAppRoute.goToRoute(
            TargetDetailsScreen(target: settings.arguments as TargetModel),
            CustomAppRoute.targetDetailsScreen);
      default:
        return CustomAppRoute.goToRoute(
            const ErrorScreen(), CustomAppRoute.errorScreen);
    }
  }
}
