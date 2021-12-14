import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/target_model.dart';

class TargetDetailsScreen extends StatelessWidget {
  final TargetModel target;
  const TargetDetailsScreen({
    Key? key,
    required this.target,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat formattedDate = DateFormat("EEEE, dd MMMM yyyy");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Target Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  formattedDate.format(target.dateTime),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: SizedBox(
                  height: 50.0,
                  child: CircleAvatar(
                    radius: 10.0,
                    backgroundColor:
                        TargetModel.getTargetColor(target.dateTime),
                  ),
                ),
              ),
              Column(
                children: target.goalsList.map((goal) {
                  return Card(
                    child: ListTile(
                      title: Text(goal.label),
                      trailing: goal.complete
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.check_circle_outline_rounded,
                            ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
