import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/goals_model.dart';
import '../data/constant_data.dart';
import '../models/target_model.dart';
import '../config/custom_app_route.dart';
import '../widgets/add_target_widget.dart';
import '../widgets/drawer_navigation_widget.dart';

class TargetScreen extends StatelessWidget {
  const TargetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    int targetIndex = 0;
    DateTime _currentDateTime = DateTime.parse("1998-12-28");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Target"),
        centerTitle: true,
      ),
      drawer: const DrawerNavigationWidget(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("targets")
              .where("uid", isEqualTo: user!.uid)
              .orderBy("dateTime", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            targetIndex = 0;

            if (snapshot.hasData) {
              if (snapshot.data!.size > 0) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: snapshot.data!.docs.map(
                    (target) {
                      String formattedDate = DateFormat("EEEE, dd MMMM yyyy")
                          .format(target["dateTime"].toDate());

                      if (targetIndex < 1) {
                        _currentDateTime = target["dateTime"].toDate();
                      }

                      targetIndex += 1;

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
                        key: Key(target["id"]),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                CustomAppRoute.targetDetailsScreen,
                                arguments: {
                                  "targetDocId": target.id,
                                },
                              );
                            },
                            leading: SizedBox(
                              height: 50.0,
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: TargetModel.getTargetColor(
                                    target["dateTime"].toDate()),
                              ),
                            ),
                            title: Text(
                              "TARGET #$targetIndex",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(formattedDate),
                          ),
                        ),
                        onDismissed: (direction) async {
                          // * Hapus target.

                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          CollectionReference targetsCollection =
                              firestore.collection(kTargetsCollection);

                          await targetsCollection
                              .doc(target.id)
                              .delete()
                              .whenComplete(
                                () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Target berhasil dihapus!"),
                                  ),
                                ),
                              );
                        },
                      );
                    },
                  ).toList(),
                );
              } else {
                return const Center(
                  child: Text("Target masih kosong."),
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
        onPressed: () async {
          // * Add target

          final goalsCollection = await FirebaseFirestore.instance
              .collection(kGoalsCollection)
              .where("uid", isEqualTo: user.uid)
              .orderBy("dateTime")
              .get();

          final List<GoalsModel> goalsList = goalsCollection.docs
              .map((goal) => GoalsModel.fromJson({
                    "id": goal.data()["id"],
                    "uid": goal.data()["uid"],
                    "label": goal.data()["label"],
                    "dateTime": goal.data()["dateTime"].toDate(),
                    "complete": goal.data()["complete"],
                  }))
              .toList();

          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AddTargetWidget(
                  goalsList: goalsList,
                  currentDateTime: _currentDateTime,
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
