import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../enum/goals_enum.dart';
import '../data/constant_data.dart';
import '../models/goals_model.dart';
import '../widgets/add_edit_goals_widget.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Goals"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(kGoalsCollection)
              .where("uid", isEqualTo: user!.uid)
              .orderBy("dateTime")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.size > 0) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: snapshot.data!.docs.map((goal) {
                    return Dismissible(
                      background: Container(
                        color: Colors.red.shade300,
                        child: const Center(
                          child: Text(
                            "Hapus?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      key: Key(goal.id),
                      child: Card(
                        child: ListTile(
                          title: Text(goal["label"]),
                          leading: const SizedBox(
                            width: 15.0,
                            height: double.infinity,
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.teal,
                                radius: 8.0,
                              ),
                            ),
                          ),
                          subtitle: Text(
                              "${GoalsModel.getTimeOnly(goal['startTime'])} - ${GoalsModel.getTimeOnly(goal['endTime'])}"),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddEditGoalsWidget(
                                  title: "Edit Goals",
                                  goalsType: GoalsType.edit,
                                  goals: GoalsModel.fromJson({
                                    "uid": goal["uid"],
                                    "id": goal["id"],
                                    "label": goal["label"],
                                    "dateTime": goal["dateTime"].toDate(),
                                    "complete": goal["complete"],
                                    "startTime": goal["startTime"].toDate(),
                                    "endTime": goal["endTime"].toDate(),
                                  }),
                                  goalsDocId: goal.id,
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                      onDismissed: (direction) async {
                        // * Hapus goals.

                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        CollectionReference goalsCollection =
                            firestore.collection(kGoalsCollection);

                        await goalsCollection.doc(goal.id).delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Goals berhasil dihapus!"),
                          ),
                        );
                      },
                    );
                  }).toList(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddEditGoalsWidget(
              title: "Tambah Goals",
              goalsType: GoalsType.add,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
