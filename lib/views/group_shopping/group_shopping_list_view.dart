import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/firestore_provider.dart';
import 'package:list_split/services/models/firestore_models.dart';
import 'package:list_split/views/group_shopping/group_shopping_view.dart';

class GroupListView extends ConsumerStatefulWidget {
  final String groupUid;

  const GroupListView({required this.groupUid, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupListViewState();
}

class _GroupListViewState extends ConsumerState<GroupListView> {
  FirestoreThing? editThing;
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
    Group? group = ref.watch(groupProvider(widget.groupUid)).value?.data();
    if (group == null) {
      return const Center(
        child: Text('Error :( \n something went terribly wrong'),
      );
    } else {
      return showHistory
          ? historyView(
              context,
              group.copyWith(
                  things: group.things
                      .where((thing) => thing.bought == true)
                      .toList()),
              group.things.where((thing) => thing.bought == false).toList())
          : thingView(
              context,
              group.copyWith(
                  things: group.things
                      .where((thing) => thing.bought == false)
                      .toList()),
              group.things.where((thing) => thing.bought == true).toList());
    }
  }

  Widget thingView(
      BuildContext context, Group group, List<FirestoreThing> rest) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              group.description,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: ListView.builder(
                  itemCount: group.things.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          editThing = group.things[index];
                        });
                        _newThingController.text = group.things[index].name;
                        _thingEditNode.requestFocus();
                      },
                      onHorizontalDragEnd: (details) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GroupShoppingView(
                              group: group,
                              allthings: group.things,
                              firstThing: group.things[index],
                              rest: rest,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (group.things[index].bought
                                ? Colors.yellow
                                : Colors.transparent),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Text(
                            group.things[index].name,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
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
                      hintText: 'add a new thing',
                    ),
                    onSubmitted: (String text) {
                      setState(() {
                        if (editThing == null) {
                          ref.read(firestoreProvider).addThing(
                              group.uid,
                              FirestoreThing(
                                  groupUid: group.uid,
                                  name: text,
                                  bought: false));
                        } else {
                          ref.read(firestoreProvider).updateThing(group,
                              editThing!, editThing!.copyWith(name: text));
                        }

                        editThing = null;
                      });

                      _newThingController.clear();
                    },
                  ),
                ),
                (editThing != null
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            ref
                                .read(firestoreProvider)
                                .removeThing(group.uid, editThing!);
                          });
                          FocusScope.of(context).unfocus();
                          _newThingController.clear();
                          editThing = null;
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

  Widget historyView(
      BuildContext context, Group group, List<FirestoreThing> rest) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              group.description,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: ListView.builder(
                  itemCount: group.things.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          editThing = group.things[index];
                        });
                        _newThingController.text = group.things[index].name;
                        _thingEditNode.requestFocus();
                      },
                      onHorizontalDragEnd: (details) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GroupShoppingView(
                              group: group,
                              allthings: group.things,
                              firstThing: group.things[index],
                              rest: rest,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (group.things[index].bought
                                ? Colors.yellow
                                : Colors.transparent),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                            child: Text(
                              group.things[index].name,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    showHistory = false;
                  });
                },
                icon: const Icon(Icons.expand_more)),
          ],
        ),
      ),
    );
  }
}
