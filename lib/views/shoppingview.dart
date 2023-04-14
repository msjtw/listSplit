import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/correctcost.dart';
import '../services/models.dart';

class ShoppingView extends StatefulWidget {
  final ShoppingList list;
  final int firstThingUuid;
  

  const ShoppingView(
      {required this.list, required this.firstThingUuid, super.key});

  @override
  State<ShoppingView> createState() => _ShoppingViewState();
}

class _ShoppingViewState extends State<ShoppingView> {
  List<Thing> chosenThings = [];
  TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chosenThings = widget.list.things
        .where((thing) => thing.uuid == widget.firstThingUuid)
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    costController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
          PastShopping(
              uuid: -1, things: chosenThings, listUuid: widget.list.uuid),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('delete things from ${widget.list.name}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'things',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'chosen',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
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
                      child: Row(
                        children: [
                          chosenThings.contains(widget.list.things[index])
                              ? Flexible(child: Container())
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: (chosenThings
                                        .contains(widget.list.things[index])
                                    ? Colors.yellow
                                    : Colors.transparent),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6)),
                              ),
                              child: Text(
                                widget.list.things[index].name,
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
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                    'You\'ve marked ${chosenThings.length} ${chosenThings.length > 1 ? 'things' : 'thing'}'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 211, 211, 211),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      height: 200,
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: chosenThings.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(chosenThings[index].name);
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0123456789,.]')),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      costController.text = "";
                      Navigator.pop(context);
                    },
                    child: const Text('discard'),
                  ),
                  TextButton(
                    onPressed: () {
                      String? cost = correctCost(costController.text);
                      if (cost != null) {
                        PastShopping save = PastShopping(
                            things: chosenThings,
                            listUuid: widget.list.uuid,
                            cost: cost.isNotEmpty ? double.parse(cost) : -1);
                        Navigator.pop(context);
                        Navigator.pop(context, save);
                      }
                    },
                    child: const Text('save'),
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
