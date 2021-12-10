import 'package:flutter/material.dart';

class AddEditGoalsWidget extends StatelessWidget {
  const AddEditGoalsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController goalsController = TextEditingController();

    return AlertDialog(
      title: const Text(
        "Tambah Goals",
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
            Navigator.pop(context);
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
