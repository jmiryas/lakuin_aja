import 'package:intl/intl.dart';
import 'package:lakuin_aja/widgets/alert_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../models/goals_model.dart';
import '../data/constant_data.dart';
import '../widgets/drawer_navigation_widget.dart';

class TargetScreen extends StatelessWidget {
  const TargetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    List<GoalsModel?> _selectedGoalsList = [];
    DateTime _currentDateTime = DateTime.now();

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
            if (snapshot.hasData) {
              if (snapshot.data!.size > 0) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: snapshot.data!.docs.map((target) {
                    String formattedDate = DateFormat("dd MMMM yyyy")
                        .format(target["dateTime"].toDate());

                    _currentDateTime = target["dateTime"].toDate();

                    return Card(
                      child: ListTile(
                        title: Text("Target $formattedDate"),
                      ),
                    );
                  }).toList(),
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
                return AlertDialog(
                  title: const Text(
                    "Tambah Target",
                    textAlign: TextAlign.center,
                  ),
                  content: StatefulBuilder(builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          MultiSelectDialogField(
                            title: const Text(
                              "Pilih Goals",
                              textAlign: TextAlign.center,
                            ),
                            buttonText: const Text("Pilih Goals"),
                            buttonIcon: const Icon(Icons.expand_more),
                            items: goalsList
                                .map((goal) => MultiSelectItem<GoalsModel?>(
                                    goal, goal.label))
                                .toList(),
                            listType: MultiSelectListType.LIST,
                            onConfirm: (values) {
                              _selectedGoalsList = values as List<GoalsModel?>;
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  actions: [
                    TextButton(
                      child: const Text("Batal"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text("Simpan"),
                      onPressed: () async {
                        if (_selectedGoalsList.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertWidget(
                                  title: "Error!",
                                  content: "Goals tidak boleh kosong.");
                            },
                          );
                        } else {
                          if (_currentDateTime.day == DateTime.now().day &&
                              _currentDateTime.month == DateTime.now().month &&
                              _currentDateTime.year == DateTime.now().year) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertWidget(
                                    title: "Error!",
                                    content: "Target hari ini sudah ada.");
                              },
                            );
                          } else {
                            const uuid = Uuid();

                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            CollectionReference targetsCollection =
                                firestore.collection(kTargetsCollection);

                            await targetsCollection.add({
                              "id": uuid.v4(),
                              "uid": user.uid,
                              "dateTime": DateTime.now(),
                              "goalsList": _selectedGoalsList
                                  .map((item) => item!.toMap())
                                  .toList()
                            });

                            _selectedGoalsList.clear();

                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Target berhasil dibuat!"),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
