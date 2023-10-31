import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/firestore_provider.dart';
import 'package:list_split/services/datestring.dart';
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
        child: CircularProgressIndicator(),
      );
    } else {
      return showHistory
          ? getHistoryView(context, group)
          : thingView(context, group);
    }
  }

  Widget thingView(BuildContext context, Group group) {
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
                      onTap: () {
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
                              isNew: true,
                              group: group.copyWith(things: [
                                for (var thing in group.things)
                                  if (thing.uid != group.things[index].uid)
                                    thing
                                  else
                                    thing.copyWith(bought: true)
                              ]),
                              shopping:
                                  FirestorePastShopping(groupUid: group.uid),
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

  Widget getHistoryView(BuildContext context, Group group) {
    final pastShoppings = ref.watch(pastShoppingsProvider(group.uid));
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
      ),
      body: pastShoppings.when(
        error: (error, stackTrace) => const Center(
          child: Text('Uh oh. Something went wrong!'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        data: (data) {
          var shoppings = data.docs;
          return Padding(
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
                      itemCount: shoppings.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GroupShoppingView(
                                    isNew: false,
                                    group: group,
                                    shopping: shoppings[index].data(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.amberAccent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(shoppings[index].data().uid),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dateString(
                                              shoppings[index].data().time),
                                        ),
                                        (shoppings[index].data().cost != -1
                                            ? Text(shoppings[index]
                                                .data()
                                                .cost
                                                .toString())
                                            : Container())
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: shoppings[index]
                                            .data()
                                            .things
                                            .length,
                                        itemBuilder:
                                            (BuildContext context, int kndex) {
                                          return Center(
                                            child: Text(shoppings[index]
                                                .data()
                                                .things[kndex]
                                                .name),
                                          );
                                        })
                                  ],
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
                  icon: const Icon(Icons.expand_more),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
