import 'package:flutter/material.dart';
import 'package:list_split/services/models/firestore_models.dart';
import 'package:list_split/services/you_sure_prompt.dart';

Future<Group?> groupNameChange(BuildContext context, Group group) async {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  nameController.text = group.name;
  descriptionController.text = group.description;

  return showDialog<Group>(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: const Center(
              child: Text('Change group details'),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "add name"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(hintText: "add description"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.cancel)),
                    IconButton(
                        onPressed: () {
                          if (nameController.text != '') {
                            Navigator.pop(
                              context,
                              group.copyWith(
                                name: nameController.text,
                                description: descriptionController.text,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.done)),
                  ],
                ),
                (group.name.isNotEmpty
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          bool? areTheySure = await youSure(context);
                          if (areTheySure == true) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('delete list'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                      )
                    : Container())
              ],
            ),
          ),
        );
      });
}
