import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/firestore_provider.dart';
import 'package:list_split/services/models/firestore_models.dart';

class GroupShoppingView extends StatefulWidget {
  final Group group;
  final List<FirestoreThing> allthings;
  final List<FirestoreThing> rest;
  final FirestoreThing firstThing;

  const GroupShoppingView(
      {required this.group,
      required this.allthings,
      required this.rest,
      required this.firstThing,
      super.key});

  @override
  State<GroupShoppingView> createState() => _GroupShoppingViewState();
}

class _GroupShoppingViewState extends State<GroupShoppingView> {
  List<FirestoreThing> allThings = [];

  @override
  void initState() {
    super.initState();

    allThings = widget.allthings;
    allThings[allThings.indexOf(widget.firstThing)] =
        widget.firstThing.copyWith(bought: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('delete things from ${widget.group.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.list_alt),
                Icon(Icons.shopping_cart_checkout),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: allThings.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        allThings[index] = allThings[index]
                            .copyWith(bought: !allThings[index].bought);
                      });
                    },
                    child: Row(
                      children: [
                        allThings[index].bought
                            ? Flexible(child: Container())
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: (allThings[index].bought
                                  ? Colors.yellow
                                  : Colors.transparent),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Text(
                              allThings[index].name,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ShoppingCheckView(allThings, widget.group, widget.rest),
            ),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class ShoppingCheckView extends ConsumerStatefulWidget {
  final List<FirestoreThing> things;
  final List<FirestoreThing> rest;
  final Group group;

  const ShoppingCheckView(this.things, this.group, this.rest, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShoppingCheckViewState();
}

class _ShoppingCheckViewState extends ConsumerState<ShoppingCheckView> {
  TextEditingController costController = TextEditingController();

  List<FirestoreThing> boughtThings = [];

  @override
  void initState() {
    super.initState();
    boughtThings =
        widget.things.where((thing) => thing.bought == true).toList();
    // costController.text =
    //     widget.shopping.cost != -1 ? widget.shopping.cost.toString() : '';
  }

  @override
  void dispose() {
    super.dispose();
    costController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'You\'ve marked ${boughtThings.length} ${boughtThings.length == 1 ? 'thing' : 'things'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 211, 211, 211),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: boughtThings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(boughtThings[index].name);
                    }),
              ),
            ),
            // Row(
            //   children: [
            //     const Text('add cost:'),
            //     const SizedBox(width: 10),
            //     SizedBox(
            //       width: 50,
            //       child: TextField(
            //         controller: costController,
            //         keyboardType:
            //             const TextInputType.numberWithOptions(decimal: true),
            //         inputFormatters: [
            //           FilteringTextInputFormatter.allow(
            //               RegExp('[0123456789,.]')),
            //         ],
            //       ),
            //     )
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('discard'),
                ),
                TextButton(
                  onPressed: () {
                    //double? cost = correctCost(costController.text);
                    ref.read(firestoreProvider).updateAllThings(
                        widget.group, widget.things + widget.rest);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
