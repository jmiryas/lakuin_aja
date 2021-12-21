import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';
import '../data/constant_data.dart';
import '../config/custom_app_route.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    TextEditingController _taskController = TextEditingController();
    int _selectedColor = colorList[0];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Task"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(kTasksCollection)
              .where("uid", isEqualTo: user!.uid)
              .orderBy("dateTime", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.size > 0) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: snapshot.data!.docs.map((task) {
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
                      key: Key(task["id"]),
                      onDismissed: (direction) async {
                        // * Hapus task.

                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        CollectionReference tasksCollection =
                            firestore.collection(kTasksCollection);

                        await tasksCollection
                            .doc(task.id)
                            .delete()
                            .whenComplete(
                              () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Task berhasil dihapus!"),
                                ),
                              ),
                            );
                      },
                      child: Card(
                        child: ListTile(
                          leading: SizedBox(
                            height: 50.0,
                            child: CircleAvatar(
                              radius: 10.0,
                              backgroundColor: Color(task["color"]),
                            ),
                          ),
                          title: Text(task["label"]),
                          subtitle: Text("${task['todos'].length}"),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_rounded,
                          ),
                          onTap: () {
                            final currentTask = TaskModel.fromJson({
                              "id": task["id"],
                              "uid": task["uid"],
                              "label": task["label"],
                              "color": task["color"],
                              "todos": task["todos"],
                              "dateTime": task["dateTime"],
                            });

                            Navigator.pushNamed(
                              context,
                              CustomAppRoute.taskItemScreen,
                              arguments: {
                                "taskId": task.id,
                                "task": currentTask,
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return const Center(
                  child: Text("Task masih kosong"),
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
          // Navigator.pushNamed(context, CustomAppRoute.addTodoScreen);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    "Tambah Task",
                    textAlign: TextAlign.center,
                  ),
                  content: StatefulBuilder(builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _taskController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                                labelText: "Nama task",
                                hintText: "Misal: Membuat Konten"),
                          ),
                          const SizedBox(
                            height: 35.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Warna Task"),
                              Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: Color(_selectedColor),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: colorList.map((color) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = color;
                                  });
                                },
                                child: Container(
                                  width: 30.0,
                                  height: 30.0,
                                  margin: const EdgeInsets.only(
                                      right: 10.0, bottom: 10.0),
                                  decoration: BoxDecoration(
                                    color: Color(color),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
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
                        if (_taskController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text(
                                  "Error!",
                                  textAlign: TextAlign.center,
                                ),
                                content: Text("Task tidak boleh kosong!"),
                              );
                            },
                          );
                        } else {
                          const uuid = Uuid();

                          TaskModel task = TaskModel(
                            id: uuid.v4(),
                            uid: user.uid,
                            label: _taskController.text,
                            color: _selectedColor,
                            dateTime: DateTime.now(),
                          );

                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          CollectionReference tasksCollection =
                              firestore.collection(kTasksCollection);

                          await tasksCollection
                              .add(task.toMap())
                              .whenComplete(() {
                            Navigator.pop(context);

                            _taskController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Task berhasil dibuat!"),
                              ),
                            );
                          });
                        }

                        // Navigator.pop(context);
                      },
                      child: const Text("Simpan"),
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
