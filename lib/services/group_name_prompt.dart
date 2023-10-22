import 'package:flutter/material.dart';
import 'package:list_split/providers/shoppinglistprovider.dart';
import 'package:list_split/services/models/firestore_models.dart';
import 'package:list_split/services/you_sure_prompt.dart';

import 'models/objectbox_models.dart';

Future<ShoppingList?> nameAndDescriptionChange(
    BuildContext context, ref, int? groupUid) async {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  late Group group;

  if (groupUid == null) {
    group = Group();
  } 
  // else {
  //   list = ref
  //       .read(shoppingListsProvider)
  //       .where((list) => list.uuid == listUuid)
  //       .first;
  // }

  nameController.text = group.name;
  descriptionController.text = group.description;
  

  return showDialog<ShoppingList>(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Center(
              child: Text((groupUid == null
                  ? 'Create a new shoppinglist'
                  : 'Change details')),
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
                                list.copyWith(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                ));
                          }
                        },
                        icon: const Icon(Icons.done)),
                  ],
                ),
                (groupUid != null
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          bool? areTheySure = await youSure(context);
                          if (areTheySure == true) {
                            Navigator.pop(context);
                            ref
                                .read(shoppingListsProvider.notifier)
                                .removelist(list);
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
