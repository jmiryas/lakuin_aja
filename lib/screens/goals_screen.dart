import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/constant_data.dart';
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
                        ),
                      ),
                      onDismissed: (direction) async {
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
            builder: (context) => const AddEditGoalsWidget(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
