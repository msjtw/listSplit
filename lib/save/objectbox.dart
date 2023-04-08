import 'models.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  late final Box<Thing> thingsBox;
  late final Box<ShoppingList> shoppingListBox;
  late final Box<PastShopping> pastShoppingBox;

  ObjectBox._create(this.store) {
    thingsBox = Box<Thing>(store);
    shoppingListBox = Box<ShoppingList>(store);
    pastShoppingBox = Box<PastShopping>(store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void saveShoppingList(ShoppingList list) {
    shoppingListBox.put(list);
  }

  void eraseShoppingList(ShoppingList list) {
    shoppingListBox.remove(list.uuid);
  }

  void saveThing(Thing thing) {
    thingsBox.put(thing);
  }

  void eraseThing(Thing thing) {
    thingsBox.remove(thing.uuid);
  }

  PastShopping savePastShopping(PastShopping shopping) {
    int shoppingId = pastShoppingBox.put(shopping);
    for (int i = 0; i < shopping.things.length; i++) {
      shopping.things[i] = shopping.things[i].copyWith(listUuid: shoppingId);
    }
    for (var thing in shopping.things) {
      thingsBox.put(thing);
    }
    return shopping;
  }

  List<ShoppingList> readAll() {
    var lists = shoppingListBox.getAll();
    for (int i = 0; i < lists.length; i++) {
      Query<Thing> thingQuery =
          thingsBox.query(Thing_.listUuid.equals(lists[i].uuid)).build();
      Query<PastShopping> shoppingQuery = pastShoppingBox
          .query(PastShopping_.listUuid.equals(lists[i].uuid))
          .build();
      List<PastShopping> shoppings = shoppingQuery.find();
      for (int k = 0; k < shoppings.length; k++) {
        Query<Thing> shoppingThingQuery =
            thingsBox.query(Thing_.listUuid.equals(shoppings[k].uuid)).build();
        shoppings[k] = shoppings[k].copyWith(things: shoppingThingQuery.find());
        shoppingThingQuery.close();
      }
      lists[i] = lists[i]
          .copyWith(things: thingQuery.find(), pastShoppings: shoppings);
      thingQuery.close();
      shoppingQuery.close();
    }

    return lists;
  }
}
