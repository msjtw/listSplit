import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shoppinglistprovider.dart';

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
    return showHistory ? historyView(context) : thingView(context);
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

  Widget historyView(BuildContext context) {
    final ShoppingList list = ref
        .watch(shoppingListsProvider)
        .where((list) => list.uuid == widget.uuid)
        .first;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('history of list ${list.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            (list.pastShoppings.isEmpty
                ? const Expanded(
                    child:
                        Center(child: Text('You dont have any past shoppings')))
                : Expanded(
                    child: ListView.builder(
                      itemCount: list.pastShoppings.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Colors.limeAccent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  (list.pastShoppings[index].name == ''
                                      ? Container(
                                          height: 0,
                                        )
                                      : Text(list.pastShoppings[index].name)),
                                  Row(
                                    children: [
                                      Text(list.pastShoppings[index].time
                                          .toString()),
                                      Flexible(child: Container()),
                                      Text(
                                          'cost: ${list.pastShoppings[index].cost}')
                                    ],
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: list
                                          .pastShoppings[index].things.length,
                                      itemBuilder:
                                          (BuildContext context, kndex) {
                                        return Text(list.pastShoppings[index]
                                            .things[kndex].name);
                                      })
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            IconButton(
                onPressed: () => setState(() {
                      showHistory = false;
                    }),
                icon: const Icon(Icons.expand_more))
          ],
        ),
      ),
    );
  }

  Widget thingView(BuildContext context) {
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
                      onLongPress: () {
                        setState(() {
                          editUuid = list.things[index].uuid;
                        });
                        _newThingController.text = list.things[index].name;
                        _thingEditNode.requestFocus();
                      },
                      onHorizontalDragEnd: (details) async {
                        PastShopping shopping = await _getNewShopping(
                            context, list, list.things[index].uuid);
                        if (shopping.uuid != "" && shopping.things.isNotEmpty) {
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
                        list.things[index].name,
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
                              list.uuid, Thing(listUuid: list.uuid, name: text, bought: false));
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
                child: Row(
                  children: [
                    chosenThings.contains(widget.list.things[index])
                        ? Flexible(child: Container())
                        : Container(),
                    Text(
                      widget.list.things[index].name,
                      style: TextStyle(
                          backgroundColor:
                              (chosenThings.contains(widget.list.things[index])
                                  ? Colors.yellow
                                  : Colors.transparent)),
                    ),
                  ],
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
                    child: const Text('add details'),
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
