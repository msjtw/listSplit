import 'package:flutter/material.dart';

Future<String?> getGroupUidPrompt(BuildContext context) async {
  final uidController = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add group'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              //const Text("Group Uid"),
              TextField(
                controller: uidController,
                decoration: const InputDecoration(hintText: "Group Uid"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text('add'),
                    onPressed: () {
                      Navigator.of(context).pop(uidController.text);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
