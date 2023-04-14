import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../providers/shoppinglistprovider.dart';
import '../services/models.dart';
import 'shoppinglistview.dart';

class AllListView extends ConsumerWidget {
  const AllListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<ShoppingList> shoppingLists = ref.watch(shoppingListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your shopping lists'),
      ),
      body: ListView.builder(
        itemCount: shoppingLists.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            shoppingLists[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Flexible(
                            child: Container(),
                          ),
                          IconButton(
                              onPressed: () async {
                                var list = await _nameAndDescriptionChange(
                                    context, ref, shoppingLists[index].uuid);
                                if (list != null) {
                                  ref
                                      .read(shoppingListsProvider.notifier)
                                      .editList(
                                          list, list.name, list.description);
                                }
                              },
                              icon: const Icon(Icons.menu))
                        ],
                      ),
                      const SizedBox(height: 10),
                      (shoppingLists[index].description == ''
                          ? Container(
                              height: 0,
                            )
                          : Column(
                              children: [
                                Text(shoppingLists[index].description),
                                const SizedBox(height: 10),
                              ],
                            )),
                      Text(
                          'You have ${shoppingLists[index].things.length} things to buy'),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ShoppingListView(uuid: shoppingLists[index].uuid)));
              },
              onLongPress: () async {
                var list = await _nameAndDescriptionChange(
                    context, ref, shoppingLists[index].uuid);
                if (list != null) {
                  ref
                      .read(shoppingListsProvider.notifier)
                      .editList(list, list.name, list.description);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _nameAndDescriptionChange(context, ref, null).then(
            (list) {
              if (list != null) {
                ref.read(shoppingListsProvider.notifier).addList(list);

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShoppingListView(uuid: list.uuid)));
              }
            },
          );
        },
        label: const Text('New List'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<ShoppingList?> _nameAndDescriptionChange(
      BuildContext context, ref, int? listUuid) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    late ShoppingList list;

    if (listUuid == null) {
      list = ShoppingList(name: '');
    } else {
      list = ref
          .read(shoppingListsProvider)
          .where((list) => list.uuid == listUuid)
          .first;
    }

    if (listUuid != null) {
      nameController.text = list.name;
      descriptionController.text = list.description;
    }

    return showDialog<ShoppingList>(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              title: Center(
                child: Text((listUuid == null
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
                  (listUuid != null
                      ? ElevatedButton.icon(
                          onPressed: () async {
                            bool? areTheySure = await _youSure(context);
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

  Future<bool?> _youSure(BuildContext context) async {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              title: const Text('Are you sure?'),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.done),
                  label: const Text('yep'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('hell no'),
                ),
              ],
            ),
          );
        });
  }
}
