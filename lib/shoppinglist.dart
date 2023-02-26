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

class PastShopping {
  int id = 0;
  String name = "";
  int time = 0;
  List<String> users = [];
  List<Thing> things = [];
  int cost = 0;

  PastShopping(this.id, this.name, this.time, this.cost, this.things);
}

class ShoppingList extends StatefulWidget {
  List<Thing> things = [];
  int id = 0;
  String name = "New shopping list";
  String description = "add description";
  bool archived = false;
  bool edit = false;

  ShoppingList(this.id, this.name, this.things, {super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  var _newThingController = TextEditingController();
  var _descriptionChangeController = TextEditingController();

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
                  return Text(widget.things[index].name);
                },
              ),
            ),
            TextField(
              controller: _newThingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'add new thing',
              ),
              onSubmitted: (String text) {
                print(text);
                setState(() {
                  widget.things.add(Thing(1, text, false));
                });
                _newThingController.clear();
              },
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

// Column(
//         children: [
//           Text(widget.description),
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.things.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Text(
//                   widget.things[index].name,
//                   style: TextStyle(
//                     decoration: (widget.things[index].bought
//                         ? TextDecoration.lineThrough
//                         : TextDecoration.none),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),

// floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() => widget.edit = true);
//         },
//         child: Icon(Icons.add),
//       ),