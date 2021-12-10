import 'package:flutter/material.dart';

import '../widgets/add_edit_goals_widget.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Goals"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddEditGoalsWidget(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
