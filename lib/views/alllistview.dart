import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/authprovider.dart';
import 'package:list_split/providers/firestore_provider.dart';
import 'package:list_split/services/models/firestore_models.dart';
import 'package:list_split/services/prompts/shoppinglist_name_prompt.dart';
import 'package:list_split/views/group_shopping/group_shopping_list_view.dart';

import '../providers/shoppinglistprovider.dart';
import '../services/bnb.dart';
import '../services/models/objectbox_models.dart';
import 'local_shoppinglist/shoppinglistview.dart';

class AllListView extends ConsumerStatefulWidget {
  const AllListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllListViewState();
}

class _AllListViewState extends ConsumerState<AllListView> {
  @override
  Widget build(BuildContext context) {
    List<ShoppingList> shoppingLists = ref.watch(shoppingListsProvider);
    User? user = ref.watch(firebaseAuthProvider).getUser;
    List<Group> groups = [];
    if (user != null) {
      groups = ref
              .watch(userGroupsProvider(user.uid))
              .value
              ?.docs
              .map((e) => e.data())
              .toList() ??
          [];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your shopping lists'),
      ),
      bottomNavigationBar: const BNB(),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: groups.length,
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.groups),
                              Text(
                                '  ${groups[index].name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              Flexible(
                                child: Container(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 0),
                          (groups[index].description.isEmpty
                              ? Container(
                                  height: 0,
                                )
                              : Column(
                                  children: [
                                    Text(
                                      groups[index].description,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )),
                          Text(
                              'You have ${groups[index].things.length} things to buy'),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupListView(groupUid: groups[index].uid),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
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
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
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
                                        context,
                                        ref,
                                        shoppingLists[index].uuid);
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
        ],
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
