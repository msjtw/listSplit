import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shoppinglistprovider.dart';
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
                      Text(
                        shoppingLists[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
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
                      .editList(list.uuid, list.name, list.description);
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
      BuildContext context, ref, String? listUuid) async {
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
                  )
                ],
              ),
            ),
          );
        });
  }
}
