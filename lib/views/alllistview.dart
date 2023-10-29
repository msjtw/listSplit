import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/services/prompts/shoppinglist_name_prompt.dart';

import '../providers/shoppinglistprovider.dart';
import '../services/bnb.dart';
import '../services/models/objectbox_models.dart';
import 'local_shoppinglist/shoppinglistview.dart';

class AllListView extends ConsumerWidget {
  const AllListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<ShoppingList> shoppingLists = ref.watch(shoppingListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your shopping lists'),
      ),
      bottomNavigationBar: const BNB(),
      body: ListView.builder(
        itemCount: shoppingLists.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
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
                                var list = await nameAndDescriptionChange(
                                    context, ref, shoppingLists[index].uuid);
                                if (list != null) {
                                  ref
                                      .read(shoppingListsProvider.notifier)
                                      .editList(list);
                                }
                              },
                              icon: const Icon(Icons.more_vert))
                        ],
                      ),
                      const SizedBox(height: 0),
                      (shoppingLists[index].description.isEmpty
                          ? Container(
                              height: 0,
                            )
                          : Column(
                              children: [
                                Text(
                                  shoppingLists[index].description,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                ),
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ShoppingListView(uuid: shoppingLists[index].uuid),
                  ),
                );
              },
              onLongPress: () async {
                var list = await nameAndDescriptionChange(
                    context, ref, shoppingLists[index].uuid);
                if (list != null) {
                  ref.read(shoppingListsProvider.notifier).editList(list);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          nameAndDescriptionChange(context, ref, null).then(
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
}
