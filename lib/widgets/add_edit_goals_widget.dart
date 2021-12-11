import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../enum/goals_enum.dart';
import '../data/constant_data.dart';
import '../models/goals_model.dart';

class AddEditGoalsWidget extends StatelessWidget {
  final String title;
  final GoalsType? goalsType;
  final GoalsModel? goals;
  final String? goalsDocId;

  const AddEditGoalsWidget({
    required this.title,
    required this.goalsType,
    this.goals,
    this.goalsDocId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    TextEditingController goalsController = TextEditingController();

    if (goalsType == GoalsType.edit) {
      goalsController.text = goals!.label;
    }

    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: goalsController,
              decoration: const InputDecoration(
                  labelText: "Goals", hintText: "Misal: Jalan pagi"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () async {
            // * Goals tidak boleh kosong.

            if (goalsController.text.isEmpty) {
              return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    "Error!",
                    textAlign: TextAlign.center,
                  ),
                  content: const Text("Goals tidak boleh kosong!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            } else {
              // * Tambah goals.

              if (goalsType == GoalsType.add) {
                const uuid = Uuid();

                GoalsModel goals = GoalsModel(
                  uid: user!.uid,
                  id: uuid.v4(),
                  label: goalsController.text,
                  dateTime: DateTime.now(),
                );

                FirebaseFirestore firestore = FirebaseFirestore.instance;
                CollectionReference goalsCollection =
                    firestore.collection(kGoalsCollection);

                await goalsCollection.add(goals.toMap());

                goalsController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Goals berhasil dibuat!"),
                  ),
                );
              } else if (goalsType == GoalsType.edit) {
                // * Edit goals.

                FirebaseFirestore firestore = FirebaseFirestore.instance;
                CollectionReference goalsCollection =
                    firestore.collection(kGoalsCollection);

                await goalsCollection.doc(goalsDocId).update({
                  "label": goalsController.text,
                });

                goalsController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Goals berhasil diupdate!"),
                  ),
                );
              }
            }

            Navigator.pop(context);
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
