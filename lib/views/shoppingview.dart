import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shoppinglistprovider.dart';
import '../services/correctcost.dart';
import '../services/models.dart';

class ShoppingView extends StatefulWidget {
  final PastShopping pastShopping;
  final ShoppingList list;

  const ShoppingView(
      {required this.pastShopping, required this.list, super.key});

  @override
  State<ShoppingView> createState() => _ShoppingViewState();
}

class _ShoppingViewState extends State<ShoppingView> {
  List<Thing> allThings = [];

  @override
  void initState() {
    super.initState();

    allThings = widget.list.things;
    if (widget.pastShopping.uuid != 0) {
      allThings = allThings + widget.pastShopping.things;
    }
    for (int i = 0; i < allThings.length; i++) {
      allThings[i] = allThings[i].copyWith(listUuid: widget.list.uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('delete things from ${widget.list.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
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
              builder: (context) => ShoppingCheckView(
                widget.pastShopping.copyWith(things: [
                  for (var thing in allThings)
                    if (thing.bought) thing
                ]),
                widget.list.copyWith(
                  things: [
                    for (var thing in allThings)
                      if (!thing.bought) thing
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class ShoppingCheckView extends ConsumerStatefulWidget {
  final PastShopping shopping;
  final ShoppingList list;

  const ShoppingCheckView(this.shopping, this.list, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShoppingCheckViewState();
}

class _ShoppingCheckViewState extends ConsumerState<ShoppingCheckView> {
  TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    costController.text =
        widget.shopping.cost != -1 ? widget.shopping.cost.toString() : '';
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
            'You\'ve marked ${widget.shopping.things.length} ${widget.shopping.things.length == 1 ? 'thing' : 'things'}'),
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
                    itemCount: widget.shopping.things.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(widget.shopping.things[index].name);
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
                    ShoppingList list = widget.list.copyWith(
                      pastShoppings: [
                            for (var shopping in widget.list.pastShoppings)
                              if (shopping.uuid != widget.shopping.uuid)
                                shopping
                          ] +
                          [widget.shopping.copyWith(cost: cost)],
                    );
                    ref
                        .read(shoppingListsProvider.notifier)
                        .editList(list.copyWith());
                    if (widget.shopping.things.isEmpty) {
                      ref
                          .read(shoppingListsProvider.notifier)
                          .removeShopping(widget.shopping);
                    }
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
