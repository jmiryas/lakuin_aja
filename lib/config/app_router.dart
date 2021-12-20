import 'package:flutter/material.dart';

import '../screens/todo_screen.dart';
import '../screens/home_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/error_screen.dart';
import '../screens/target_screen.dart';
import '../screens/sign_in_screen.dart';
import '../config/custom_app_route.dart';
import '../screens/add_todo_screen.dart';
import '../screens/todo_item_screen.dart';
import '../screens/target_details_screen.dart';

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
        final targetArgs = settings.arguments as Map<String, dynamic>;

        return CustomAppRoute.goToRoute(
            TargetDetailsScreen(
              targetDocId: targetArgs["targetDocId"],
            ),
            CustomAppRoute.targetDetailsScreen);
      case CustomAppRoute.todoScreen:
        return CustomAppRoute.goToRoute(
            const TodoScreen(), CustomAppRoute.todoScreen);
      case CustomAppRoute.addTodoScreen:
        return CustomAppRoute.goToRoute(
            const AddTodoScreen(), CustomAppRoute.addTodoScreen);
      case CustomAppRoute.taskItemScreen:
        final taskArgs = settings.arguments as Map<String, dynamic>;

        return CustomAppRoute.goToRoute(
            TodoItemScreen(
              taskId: taskArgs["taskId"],
              task: taskArgs["task"],
            ),
            CustomAppRoute.taskItemScreen);
      default:
        return CustomAppRoute.goToRoute(
            const ErrorScreen(), CustomAppRoute.errorScreen);
    }
  }
}
