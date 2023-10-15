import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../services/models/objectbox_models.dart';

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
    objectbox.eraseShoppingList(listRef);
    state = [
      for (var list in state)
        if (list.uuid != listRef.uuid) list,
    ];
  }

  void editList(ShoppingList listRef) {
    objectbox.saveShoppingList(listRef);
    state = [
      for (var list in state)
        if (list.uuid == listRef.uuid) listRef else list
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
    objectbox.eraseThing(thingRef);
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

  void editThing(ShoppingList listRef, Thing thingRef) {
    objectbox.saveThing(thingRef);
    state = [
      for (var list in state)
        if (list.uuid == listRef.uuid)
          list.copyWith(things: [
            for (var thing in list.things)
              if (thing.uuid == thingRef.uuid) thingRef else thing
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

  void removeShopping(PastShopping shopping) {
    objectbox.erasePastShopping(shopping);
    state = [
      for (var list in state)
        if (list.uuid == shopping.listUuid)
          list.copyWith(pastShoppings: [
            for (var pastShopping in list.pastShoppings)
              if (pastShopping.uuid != shopping.uuid) pastShopping
          ])
        else
          list
    ];
  }

  void editShopping(PastShopping shoppingRef) {
    objectbox.savePastShopping(shoppingRef);
    state = [
      for (var list in state)
        if (list.uuid == shoppingRef.listUuid)
          list.copyWith(pastShoppings: [
            for (var shopping in list.pastShoppings)
              if (shopping.uuid == shoppingRef.uuid) shoppingRef else shopping
          ])
        else
          list
    ];
  }
}

final shoppingListsProvider =
    NotifierProvider<ShoppingListsNotifier, List<ShoppingList>>(() {
  return ShoppingListsNotifier();
});
