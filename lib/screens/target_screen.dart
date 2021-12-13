import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/goals_model.dart';
import '../data/constant_data.dart';
import '../widgets/add_target_widget.dart';
import '../widgets/drawer_navigation_widget.dart';

class TargetScreen extends StatelessWidget {
  const TargetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
                return AddTargetWidget(goalsList: goalsList);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
