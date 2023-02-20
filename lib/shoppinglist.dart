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
              print('cliced note $index');
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => widget.lists[index]));
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
          print(widget.listId);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widget.lists.last));
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
  int id = 0;
  String name = "New shopping list";
  String description = "add description";
  bool archived = false;

  ShoppingList(this.id, this.name, this.things, {super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Text(widget.description),
          Expanded(
            child: ListView.builder(
              itemCount: widget.things.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  widget.things[index].name,
                  style: TextStyle(
                    decoration: (widget.things[index].bought
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ShoppingListEdit extends StatefulWidget {
  const ShoppingListEdit({super.key});

  @override
  State<ShoppingListEdit> createState() => _ShoppingListEditState();
}

class _ShoppingListEditState extends State<ShoppingListEdit> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ShoppingListAddThings extends StatefulWidget {
  const ShoppingListAddThings({super.key});

  @override
  State<ShoppingListAddThings> createState() => _ShoppingListAddThingsState();
}

class _ShoppingListAddThingsState extends State<ShoppingListAddThings> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
