import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/firestore_provider.dart';
import 'package:list_split/services/correctcost.dart';
import 'package:list_split/services/models/firestore_models.dart';

class GroupShoppingView extends StatefulWidget {
  final Group group;
  final FirestorePastShopping shopping;
  final bool isNew;

  const GroupShoppingView(
      {required this.isNew,
      required this.group,
      required this.shopping,
      super.key});

  @override
  State<GroupShoppingView> createState() => _GroupShoppingViewState();
}

class _GroupShoppingViewState extends State<GroupShoppingView> {
  List<FirestoreThing> showThings = [];

  @override
  void initState() {
    super.initState();

    if (!widget.isNew) {
      showThings += widget.shopping.things;
    }
    showThings += widget.group.things;
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
                itemCount: showThings.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        showThings[index] = showThings[index]
                            .copyWith(bought: !showThings[index].bought);
                      });
                    },
                    child: Row(
                      children: [
                        showThings[index].bought
                            ? Flexible(child: Container())
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: (showThings[index].bought
                                  ? Colors.yellow
                                  : Colors.transparent),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Text(
                              showThings[index].name,
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
              builder: (context) => ShoppingCheckView(
                  widget.shopping.copyWith(
                    things: showThings
                        .where((thing) => thing.bought == true)
                        .toList(),
                  ),
                  showThings.where((thing) => thing.bought == false).toList(),
                  widget.group),
            ),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class ShoppingCheckView extends ConsumerStatefulWidget {
  final FirestorePastShopping pastShopping;
  final List<FirestoreThing> leftThings;
  final Group group;

  const ShoppingCheckView(this.pastShopping, this.leftThings, this.group,
      {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShoppingCheckViewState();
}

class _ShoppingCheckViewState extends ConsumerState<ShoppingCheckView> {
  TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    costController.text = widget.pastShopping.cost != -1
        ? widget.pastShopping.cost.toString()
        : '';
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
            'You\'ve marked ${widget.pastShopping.things.length} ${widget.pastShopping.things.length == 1 ? 'thing' : 'things'}'),
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
                    itemCount: widget.pastShopping.things.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(widget.pastShopping.things[index].name);
                    }),
              ),
            ),
            Row(
              children: [
                const Text('add cost:'),
                const SizedBox(width: 10),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: costController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp('[0123456789,.]')),
                    ],
                  ),
                )
              ],
            ),
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
                    double? cost = correctCost(costController.text);
                    ref.read(firestoreProvider).setPastShopping(
                        widget.pastShopping.copyWith(cost: cost));
                    ref
                        .read(firestoreProvider)
                        .updateAllThings(widget.group, widget.leftThings);
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
