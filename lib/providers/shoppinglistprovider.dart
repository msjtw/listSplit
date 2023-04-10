import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../save/models.dart';

class ShoppingListsNotifier extends Notifier<List<ShoppingList>> {
  @override
  List<ShoppingList> build() {
    return objectbox.readAll();
  }

  void addList(ShoppingList listRef) {
    objectbox.saveShoppingList(listRef);
    state = [...state, listRef];
  }

  void removelist(ShoppingList listRef) {
    state = [
      for (var list in state)
        if (list.uuid != listRef.uuid) list,
    ];
  }

  void editList(ShoppingList listRef, String? name, String? descripion) {
    objectbox.saveShoppingList(
        listRef.copyWith(name: name, description: descripion));
    state = [
      for (var list in state)
        if (list.uuid == listRef.uuid)
          list.copyWith(name: name, description: descripion)
        else
          list
    ];
  }

  void addThing(ShoppingList listRef, Thing thing) {
    objectbox.saveThing(thing);
    state = [
      for (var list in state)
        if (list.uuid == listRef.uuid)
          list.copyWith(things: [...list.things, thing])
        else
          list
    ];
  }

  void removeThing(ShoppingList listRef, Thing thingRef) {
    state = [
      for (var list in state)
        if (list.uuid == listRef.uuid)
          list.copyWith(things: [
            for (var thing in list.things)
              if (thing.uuid != thingRef.uuid) thing
          ])
        else
          list
    ];
  }

  void editThing(
      ShoppingList listRef, Thing thingRef, String? name, bool? bought) {
    objectbox.saveThing(thingRef.copyWith(name: name, bought: bought));
    state = [
      for (var list in state)
        if (list.uuid == listRef.uuid)
          list.copyWith(things: [
            for (var thing in list.things)
              if (thing.uuid == thingRef.uuid)
                thing.copyWith(name: name, bought: bought)
              else
                thing
          ])
        else
          list
    ];
  }

  void addShopping(PastShopping shopping) {
    PastShopping newShopping = objectbox.savePastShopping(shopping);
    state = [
      for (var list in state)
        if (list.uuid == newShopping.listUuid)
          list.copyWith(pastShoppings: [...list.pastShoppings, newShopping])
        else
          list
    ];
  }

  void editShopping;
}

final shoppingListsProvider =
    NotifierProvider<ShoppingListsNotifier, List<ShoppingList>>(() {
  return ShoppingListsNotifier();
});
