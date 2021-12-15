import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lakuin_aja/data/constant_data.dart';
import 'package:lakuin_aja/models/goals_model.dart';

import '../models/target_model.dart';

class TargetDetailsScreen extends StatelessWidget {
  final TargetModel target;
  final String targetDocId;
  const TargetDetailsScreen({
    Key? key,
    required this.target,
    required this.targetDocId,
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
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.check_circle_outline_rounded,
                            ),
                      onTap: () async {
                        List<GoalsModel> othersGoals = target.goalsList
                            .where((item) => item.id != goal.id)
                            .toList();

                        final otherGoalsMap =
                            othersGoals.map((item) => item.toMap()).toList();

                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        CollectionReference targetsCollection =
                            firestore.collection(kTargetsCollection);

                        await targetsCollection.doc(targetDocId).update(
                          {
                            "goalsList": [
                              ...otherGoalsMap,
                              GoalsModel(
                                uid: goal.uid,
                                id: goal.id,
                                label: goal.label,
                                dateTime: goal.dateTime,
                                complete: !goal.complete,
                              ).toMap(),
                            ]
                          },
                        ).whenComplete(
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Goal berhasil diupdate!"),
                            ),
                          ),
                        );
                      },
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
