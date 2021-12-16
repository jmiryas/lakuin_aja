import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

    DateTime _endTime = DateTime.now();

    if (goalsType == GoalsType.edit) {
      goalsController.text = goals!.label;
    }

    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: goalsController,
                decoration: const InputDecoration(
                    labelText: "Goals", hintText: "Misal: Jalan pagi"),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      height: 50.0,
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          "Start Time",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: 50.0,
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        "--:--",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "End Time",
                                textAlign: TextAlign.center,
                              ),
                              content: SizedBox(
                                height: 200.0,
                                child: CupertinoDatePicker(
                                  use24hFormat: true,
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (value) {
                                    setState(() => _endTime = value);
                                  },
                                  initialDateTime: DateTime.now(),
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
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"),
                                )
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      height: 50.0,
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          "End Time",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: 50.0,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        _endTime.toString().substring(10, 19),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      }),
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

              // if (goalsType == GoalsType.add) {
              //   const uuid = Uuid();

              //   GoalsModel goals = GoalsModel(
              //     uid: user!.uid,
              //     id: uuid.v4(),
              //     label: goalsController.text,
              //     dateTime: DateTime.now(),
              //   );

              //   FirebaseFirestore firestore = FirebaseFirestore.instance;
              //   CollectionReference goalsCollection =
              //       firestore.collection(kGoalsCollection);

              //   await goalsCollection.add(goals.toMap()).whenComplete(() {
              //     Navigator.pop(context);

              //     goalsController.clear();

              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //         content: Text("Goals berhasil dibuat!"),
              //       ),
              //     );
              //   });
              // } else if (goalsType == GoalsType.edit) {
              //   // * Edit goals.

              //   FirebaseFirestore firestore = FirebaseFirestore.instance;
              //   CollectionReference goalsCollection =
              //       firestore.collection(kGoalsCollection);

              //   await goalsCollection.doc(goalsDocId).update({
              //     "label": goalsController.text,
              //   }).whenComplete(() {
              //     Navigator.pop(context);

              //     goalsController.clear();

              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //         content: Text("Goals berhasil diupdate!"),
              //       ),
              //     );
              //   });
              // }
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
