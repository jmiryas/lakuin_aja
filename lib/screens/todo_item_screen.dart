import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';
import '../models/todo_model.dart';
import '../data/constant_data.dart';

class TodoItemScreen extends StatelessWidget {
  final String taskId;
  final TaskModel task;
  const TodoItemScreen({
    Key? key,
    required this.taskId,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    TextEditingController _todoItemController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Task Items"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(kTasksCollection)
              .where(FieldPath.documentId, isEqualTo: taskId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.size > 0) {
                return ListView(padding: const EdgeInsets.all(20.0), children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: snapshot.data!.docs.map((taskItem) {
                      return taskItem["todos"].length > 0
                          ? Column(
                              children: [
                                Card(
                                  child: ListTile(
                                    title: Text(
                                      task.label,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: CircleAvatar(
                                      radius: 10.0,
                                      backgroundColor: Color(task.color),
                                    ),
                                  ),
                                ),
                                ...taskItem["todos"].map((item) {
                                  return Dismissible(
                                    key: Key(item["id"]),
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
                                    onDismissed: (direction) async {
                                      // * Hapus task item.

                                      final currentTasksCollection =
                                          await FirebaseFirestore.instance
                                              .collection(kTasksCollection)
                                              .where(FieldPath.documentId,
                                                  isEqualTo: taskId)
                                              .get();

                                      List<dynamic> currentTodos =
                                          currentTasksCollection.docs
                                              .map((taskItem) =>
                                                  taskItem["todos"])
                                              .toList();

                                      List<dynamic> newTodos = currentTodos[0]
                                          .where((taskItem) =>
                                              taskItem["id"] != item["id"])
                                          .toList();

                                      FirebaseFirestore firestore =
                                          FirebaseFirestore.instance;
                                      CollectionReference tasksCollection =
                                          firestore
                                              .collection(kTasksCollection);

                                      await tasksCollection.doc(taskId).update({
                                        "todos": [
                                          ...newTodos,
                                        ],
                                      }).whenComplete(
                                        () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Task item berhasil dihapus!"),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Card(
                                      child: ListTile(
                                        title: Text(item["label"]),
                                        trailing: item["complete"]
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.teal,
                                              )
                                            : const Icon(
                                                Icons
                                                    .check_circle_outline_rounded,
                                              ),
                                        onTap: () async {
                                          // Update task item: complete or incomplete

                                          List<dynamic> taskList = [];

                                          final currentTasksCollection =
                                              await FirebaseFirestore.instance
                                                  .collection(kTasksCollection)
                                                  .where(FieldPath.documentId,
                                                      isEqualTo: taskId)
                                                  .get();

                                          List<dynamic> currentTodos =
                                              currentTasksCollection.docs
                                                  .map((taskItem) =>
                                                      taskItem["todos"])
                                                  .toList();

                                          currentTodos[0].map((itemTask) {
                                            if (itemTask["id"] == item["id"]) {
                                              taskList.add(TodoModel.fromJson({
                                                "id": itemTask["id"],
                                                "uid": itemTask["uid"],
                                                "label": itemTask["label"],
                                                "complete":
                                                    !itemTask["complete"],
                                                "dateTime":
                                                    itemTask["dateTime"],
                                              }).toMap());
                                            } else {
                                              taskList.add(itemTask);
                                            }
                                          }).toList();

                                          FirebaseFirestore firestore =
                                              FirebaseFirestore.instance;
                                          CollectionReference tasksCollection =
                                              firestore
                                                  .collection(kTasksCollection);

                                          await tasksCollection
                                              .doc(taskId)
                                              .update({
                                            "todos": [
                                              ...taskList,
                                            ],
                                          }).whenComplete(
                                            () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Task item berhasil diupdate!"),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList()
                              ],
                            )
                          : SizedBox(
                              height:
                                  MediaQuery.of(context).size.height - 150.0,
                              width: MediaQuery.of(context).size.width,
                              child: const Center(
                                child: Text("Task item masih kosong!"),
                              ),
                            );
                    }).toList(),
                  )
                ]);
              } else {
                return const Center(
                  child: Text("Task item masih kosong."),
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
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    "Task Item",
                    textAlign: TextAlign.center,
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _todoItemController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                              labelText: "Task Item",
                              hintText: "Misal: Menulis artikel blog"),
                        )
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
                        // Add new todo item

                        if (_todoItemController.text.isEmpty) {
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
                          final currentTasksCollection = await FirebaseFirestore
                              .instance
                              .collection(kTasksCollection)
                              .where(FieldPath.documentId, isEqualTo: taskId)
                              .get();

                          List<dynamic> currentTodos = currentTasksCollection
                              .docs
                              .map((taskItem) => taskItem["todos"])
                              .toList();

                          const uuid = Uuid();

                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          CollectionReference tasksCollection =
                              firestore.collection(kTasksCollection);

                          await tasksCollection.doc(taskId).update({
                            "todos": [
                              ...currentTodos[0],
                              TodoModel(
                                id: uuid.v4(),
                                uid: user!.uid,
                                label: _todoItemController.text,
                                dateTime: DateTime.now(),
                              ).toMap(),
                            ],
                          }).whenComplete(
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Task item berhasil ditambah!"),
                                ),
                              );

                              Navigator.pop(context);

                              _todoItemController.clear();
                            },
                          );
                        }
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
