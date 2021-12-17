import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/constant_data.dart';
import '../models/goals_model.dart';
import '../models/target_model.dart';

class TargetDetailsScreen extends StatelessWidget {
  final String targetDocId;
  const TargetDetailsScreen({
    Key? key,
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(kTargetsCollection)
              .where(FieldPath.documentId, isEqualTo: targetDocId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.size > 0) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: snapshot.data!.docs.map(
                        (targetItem) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  formattedDate.format(
                                    targetItem["dateTime"].toDate(),
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: SizedBox(
                                  height: 50.0,
                                  child: CircleAvatar(
                                    radius: 10.0,
                                    backgroundColor: TargetModel.getTargetColor(
                                      targetItem["dateTime"].toDate(),
                                    ),
                                  ),
                                ),
                              ),
                              ...targetItem["goalsList"].map((goal) {
                                // Mendapatkan goal saat ini

                                final currentGoal = GoalsModel.fromJson({
                                  "id": goal["id"],
                                  "uid": goal["uid"],
                                  "label": goal["label"],
                                  "dateTime": goal["dateTime"].toDate(),
                                  "complete": goal["complete"],
                                  "startTime": goal["startTime"].toDate(),
                                  "endTime": goal["endTime"].toDate(),
                                });

                                return Card(
                                  child: ListTile(
                                    title: Text(currentGoal.label),
                                    subtitle: Text(
                                        "${GoalsModel.getTimeOnlyFromDateTime(currentGoal.startTime)} - ${GoalsModel.getTimeOnlyFromDateTime(currentGoal.endTime)}"),
                                    trailing: currentGoal.complete
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.check_circle_outline_rounded,
                                          ),
                                    onTap: () async {
                                      // Lakukan iterasi, jika id tidak sama, maka
                                      // tambahkan ke dalam list apa adanya.
                                      // Jika id sama, maka ubah status complete
                                      // menjadi sebaliknya.

                                      List<dynamic> otherGoals = [];

                                      targetItem["goalsList"].map((item) {
                                        if (item["id"] != currentGoal.id) {
                                          otherGoals.add(item);
                                        } else {
                                          otherGoals.add(GoalsModel(
                                            uid: currentGoal.uid,
                                            id: currentGoal.id,
                                            label: currentGoal.label,
                                            dateTime: currentGoal.dateTime,
                                            complete: !currentGoal.complete,
                                            startTime: currentGoal.startTime,
                                            endTime: currentGoal.endTime,
                                          ).toMap());
                                        }
                                      }).toList();

                                      FirebaseFirestore firestore =
                                          FirebaseFirestore.instance;
                                      CollectionReference targetsCollection =
                                          firestore
                                              .collection(kTargetsCollection);

                                      await targetsCollection
                                          .doc(targetDocId)
                                          .update(
                                        {
                                          "goalsList": [
                                            ...otherGoals,
                                          ]
                                        },
                                      ).whenComplete(
                                        () => ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Goal berhasil diupdate!"),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              })
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text("Goals masih kosong."),
                );
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong!"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
