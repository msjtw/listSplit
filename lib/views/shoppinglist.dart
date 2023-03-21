import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shoppinglistprovider.dart';

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
          return GestureDetector(
            child: Column(
              children: [
                Text(shoppingLists[index].name),
                Text(shoppingLists[index].description),
                const SizedBox(height: 10),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ShoppingListView(uuid: shoppingLists[index].uuid)));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref
              .read(shoppingListsProvider.notifier)
              .addList(ShoppingList(name: 'new list'));
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) =>
          //         ShoppingListView(uuid: shoppingLists.last.uuid)));
        },
        label: const Text('New List'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class ShoppingListView extends ConsumerStatefulWidget {
  final String uuid;

  const ShoppingListView({required this.uuid, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShoppingListViewState();
}

class _ShoppingListViewState extends ConsumerState<ShoppingListView> {
  String editUuid = "";
  bool showHistory = false;

  final _newThingController = TextEditingController();
  final _descriptionChangeController = TextEditingController();

  late FocusNode _thingEditNode;

  @override
  void initState() {
    super.initState();

    _thingEditNode = FocusNode();
  }

  @override
  void dispose() {
    _newThingController.dispose();
    _descriptionChangeController.dispose();
    _thingEditNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingList list = ref
        .watch(shoppingListsProvider)
        .where((list) => list.uuid == widget.uuid)
        .first;
    return Scaffold(
      appBar: AppBar(
        title: Text(list.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _descriptionChange(context),
              child: Text(list.description),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: ListView.builder(
                  itemCount: list.things.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          editUuid = list.things[index].uuid;
                        });
                        _newThingController.text = list.things[index].name;
                        _thingEditNode.requestFocus();
                      },
                      onHorizontalDragEnd: (details) async {
                        PastShopping shopping = await _getNewShopping(
                            context, list, list.things[index].uuid);
                        if (shopping.uuid != "") {
                          ref
                              .read(shoppingListsProvider.notifier)
                              .addShopping(shopping);
                          for (var thing in shopping.things) {
                            ref
                                .read(shoppingListsProvider.notifier)
                                .removeThing(list.uuid, thing.uuid);
                          }
                        }
                      },
                      child: Text(
                        '${list.things[index].uuid}. ${list.things[index].name}',
                        style: TextStyle(
                            backgroundColor: (list.things[index].bought
                                ? Colors.yellow
                                : Colors.transparent)),
                      ),
                    );
                  },
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    showHistory = true;
                  });
                },
                icon: const Icon(Icons.history)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newThingController,
                    focusNode: _thingEditNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'add new thing',
                    ),
                    onSubmitted: (String text) {
                      setState(() {
                        if (editUuid == "") {
                          ref.read(shoppingListsProvider.notifier).addThing(
                              list.uuid, Thing(name: text, bought: false));
                        } else {
                          ref
                              .read(shoppingListsProvider.notifier)
                              .editThing(list.uuid, editUuid, text, false);
                        }

                        editUuid = "";
                      });

                      _newThingController.clear();
                    },
                  ),
                ),
                (editUuid != ""
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            ref
                                .read(shoppingListsProvider.notifier)
                                .removeThing(list.uuid, editUuid);
                          });
                          FocusScope.of(context).unfocus();
                          _newThingController.clear();
                          editUuid = "";
                        },
                        icon: const Icon(Icons.delete))
                    : Container(width: 0))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _descriptionChange(BuildContext context) async {
    final ShoppingList list = ref
        .read(shoppingListsProvider)
        .where((list) => list.uuid == widget.uuid)
        .first;

    if (list.description != 'add description') {
      _descriptionChangeController.text = list.description;
    } else {
      _descriptionChangeController.clear();
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change description'),
            content: TextField(
              controller: _descriptionChangeController,
              decoration: const InputDecoration(hintText: "add description"),
              onSubmitted: (newDescription) {
                setState(() {
                  Navigator.pop(context);
                  ref
                      .read(shoppingListsProvider.notifier)
                      .editList(list.uuid, list.name, newDescription);
                });
              },
            ),
          );
        });
  }

  Future<PastShopping> _getNewShopping(
      BuildContext context, ShoppingList list, String thingUuid) async {
    return await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ShoppingView(list: list, firstThingUuid: thingUuid)));
  }
}

class ShoppingView extends StatefulWidget {
  final ShoppingList list;
  final String firstThingUuid;

  const ShoppingView(
      {required this.list, required this.firstThingUuid, super.key});

  @override
  State<ShoppingView> createState() => _ShoppingViewState();
}

class _ShoppingViewState extends State<ShoppingView> {
  List<Thing> chosenThings = [];

  @override
  void initState() {
    super.initState();
    chosenThings = widget.list.things
        .where((thing) => thing.uuid == widget.firstThingUuid)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
          PastShopping(
              uuid: '', things: chosenThings, listUuid: widget.list.uuid),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('delete things from ${widget.list.name}'),
        ),
        body: ListView.builder(
          itemCount: widget.list.things.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onHorizontalDragEnd: (details) {
                setState(() {
                  if (!chosenThings.remove(widget.list.things[index])) {
                    chosenThings.add(widget.list.things[index]);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.list.things[index].name,
                  style: TextStyle(
                      backgroundColor:
                          (chosenThings.contains(widget.list.things[index])
                              ? Colors.yellow
                              : Colors.transparent)),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                    'You\'ve marked ${chosenThings.length} ${chosenThings.length > 1 ? 'things' : 'thing'}'),
                content: SizedBox(
                  height: 400,
                  width: 400,
                  child: ListView.builder(
                      itemCount: chosenThings.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(chosenThings[index].name);
                      }),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('discard'),
                  ),
                  TextButton(
                    onPressed: () {
                      PastShopping save = PastShopping(
                          things: chosenThings, listUuid: widget.list.uuid);
                      Navigator.pop(context);
                      Navigator.pop(context, save);
                    },
                    child: const Text('save'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('add cost'),
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
