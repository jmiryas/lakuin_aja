import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';
import '../models/todo_model.dart';
import '../data/constant_data.dart';
import '../providers/todo_item_provider.dart';

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
        title: const Text("Task Item"),
        actions: [
          IconButton(
            onPressed: () async {
              final todoItemProvider =
                  Provider.of<TodoItemProvider>(context, listen: false);

              FirebaseFirestore firestore = FirebaseFirestore.instance;
              CollectionReference tasksCollection =
                  firestore.collection(kTasksCollection);

              await tasksCollection.doc(taskId).update({
                "todos": [
                  ...task.todos,
                  ...todoItemProvider.todoList
                      .map((item) => item.toMap())
                      .toList()
                ],
              }).whenComplete(
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Target berhasil diupdate!"),
                    ),
                  );

                  todoItemProvider.clearTodo();
                },
              );
            },
            icon: const Icon(Icons.check_sharp),
          ),
        ],
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
                      return Column(
                        children: [
                          ...taskItem["todos"].map((item) {
                            return Card(
                              child: ListTile(
                                title: Text(item["label"]),
                                trailing: item["complete"]
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.teal,
                                      )
                                    : const Icon(
                                        Icons.check_circle_outline_rounded,
                                      ),
                              ),
                            );
                          }).toList()
                        ],
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
                          // const uuid = Uuid();

                          // final todoItemProvider =
                          //     Provider.of<TodoItemProvider>(context,
                          //         listen: false);

                          // todoItemProvider.addTodo(
                          //   TodoModel(
                          //     id: uuid.v4(),
                          //     uid: user!.uid,
                          //     label: _todoItemController.text,
                          //     dateTime: DateTime.now(),
                          //   ),
                          // );

                          // _todoItemController.clear();

                          Navigator.pop(context);
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
