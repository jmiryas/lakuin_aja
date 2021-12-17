import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../data/constant_data.dart';
import '../models/goals_model.dart';
import '../widgets/alert_widget.dart';

class AddTargetWidget extends StatelessWidget {
  final List<GoalsModel> goalsList;
  final DateTime currentDateTime;

  const AddTargetWidget({
    Key? key,
    required this.goalsList,
    required this.currentDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    List<GoalsModel?> _selectedGoalsList = [];

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
                items: goalsList.map((goal) {
                  final nameAndDate =
                      "${goal.label}\n${GoalsModel.getTimeOnlyFromDateTime(goal.startTime)} - ${GoalsModel.getTimeOnlyFromDateTime(goal.endTime)}";

                  return MultiSelectItem<GoalsModel?>(goal, nameAndDate);
                }).toList(),
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
            // * Jika goals tidak dipilih, tampilkan error

            if (_selectedGoalsList.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertWidget(
                      title: "Error!", content: "Goals tidak boleh kosong.");
                },
              );
            } else {
              // * Jika target untuk hari ini sudah ada, tampilkan error

              if (currentDateTime.day == DateTime.now().day &&
                  currentDateTime.month == DateTime.now().month &&
                  currentDateTime.year == DateTime.now().year) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertWidget(
                        title: "Error!", content: "Target hari ini sudah ada.");
                  },
                );
              } else {
                // * Tambahkan target

                const uuid = Uuid();

                FirebaseFirestore firestore = FirebaseFirestore.instance;
                CollectionReference targetsCollection =
                    firestore.collection(kTargetsCollection);

                await targetsCollection.add({
                  "id": uuid.v4(),
                  "uid": user!.uid,
                  "dateTime": DateTime.now(),
                  "goalsList":
                      _selectedGoalsList.map((item) => item!.toMap()).toList()
                }).whenComplete(() {
                  Navigator.of(context).pop();

                  _selectedGoalsList.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Target berhasil dibuat!"),
                    ),
                  );
                });
              }
            }
          },
        ),
      ],
    );
  }
}
