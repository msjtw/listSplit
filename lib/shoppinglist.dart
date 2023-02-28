import 'package:flutter/material.dart';

class ShoppingListView extends StatefulWidget {
  ShoppingListView({super.key});

  List<ShoppingList> lists = [];
  int listId = 0;

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your shopping lists'),
      ),
      body: ListView.builder(
        itemCount: widget.lists.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Column(
              children: [
                Text(widget.lists[index].name),
                Text(widget.lists[index].description),
                SizedBox(height: 10),
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => widget.lists[index]))
                  .then((_) => setState(() {}));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            widget.lists.add(ShoppingList(
                widget.listId, 'New shopping list ${widget.listId}', []));
          });
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widget.lists.last))
              .then((_) => setState(() {}));
          widget.listId++;
        },
        label: const Text('New List'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class Thing {
  int id = 0;
  String name = "";
  bool bought = false;
  Thing(this.id, this.name, this.bought);
}

class ShoppingList extends StatefulWidget {
  List<Thing> things = [];
  List<PastShopping> boughtThings = [];
  int id = 0;
  int thingId = 0;
  int pastShoppingId = 0;
  String name = "New shopping list";
  String description = "add description";
  bool archived = false;
  int thingEdit = -1;

  ShoppingList(this.id, this.name, this.things, {super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _descriptionChange(context),
              child: Text(widget.description),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.things.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        widget.thingEdit = index;
                      });
                      _newThingController.text = widget.things[index].name;
                      _thingEditNode.requestFocus();
                    },
                    child: Text(
                        '${widget.things[index].id}. ${widget.things[index].name}'),
                  );
                },
              ),
            ),
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
                        if (widget.thingEdit == -1) {
                          widget.things.add(Thing(widget.thingId, text, false));
                          widget.thingId++;
                        } else {
                          widget.things[widget.thingEdit].name = text;
                        }

                        widget.thingEdit = -1;
                      });

                      _newThingController.clear();
                    },
                  ),
                ),
                (widget.thingEdit != -1
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.things.removeAt(widget.thingEdit);
                          });
                          FocusScope.of(context).unfocus();
                          _newThingController.clear();
                          widget.thingEdit = -1;
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
    if (widget.description != 'add description') {
      _descriptionChangeController.text = widget.description;
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
              decoration: InputDecoration(hintText: "add description"),
              onSubmitted: (newDescription) {
                setState(() {
                  widget.description = newDescription;
                  Navigator.pop(context);
                });
              },
            ),
          );
        });
  }
}

class PastShopping {
  int id = 0;
  String name = "";
  int time = 0;
  List<String> users = [];
  List<Thing> things = [];
  int cost = 0;

  PastShopping(this.id, this.name, this.time, this.cost, this.things);
}

class BuyView extends StatefulWidget {
  List<Thing> things = [];
  List<Thing> boughtThings = [];
  List<Thing> leftThings = [];
  String listName = '';
  int cost = 0;

  BuyView({super.key});

  @override
  State<BuyView> createState() => _BuyViewState();
}

class _BuyViewState extends State<BuyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('delete things from ${widget.listName}'),
      ),
    );
  }
}
