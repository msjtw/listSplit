import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Thing {
  final String uuid;
  final String name;
  final bool bought;

  Thing({
    required this.name,
    required this.bought,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Thing copyWith({String? uuid, String? name, bool? bought}) {
    return Thing(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      bought: bought ?? this.bought,
    );
  }
}

@immutable
class ShoppingList {
  final String uuid;
  final List<Thing> things;
  final String name;
  final String description;
  final List<PastShopping> pastShoppings;

  ShoppingList({
    required this.name,
    String? description,
    List<Thing>? things,
    String? uuid,
    List<PastShopping>? pastShoppings,
  })  : description = description ?? 'List desctiption..',
        things = things ?? [],
        uuid = uuid ?? const Uuid().v4(),
        pastShoppings = pastShoppings ?? [];

  ShoppingList copyWith(
      {String? uuid,
      List<Thing>? things,
      String? name,
      String? description,
      List<PastShopping>? pastShoppings}) {
    return ShoppingList(
      uuid: uuid ?? this.uuid,
      things: things ?? this.things,
      name: name ?? this.name,
      description: description ?? this.description,
      pastShoppings: pastShoppings ?? this.pastShoppings,
    );
  }
}

@immutable
class PastShopping {
  final String uuid;
  final String name;
  final String listUuid;
  final DateTime time;
  final List<Thing> things;
  final int cost;

  PastShopping({
    required this.things,
    required this.listUuid,
    String? uuid,
    String? name,
    DateTime? time,
    int? cost,
  })  : uuid = uuid ?? const Uuid().v4(),
        time = time ?? DateTime.now(),
        name = name ?? DateTime.now().toString(),
        cost = cost ?? -1;

  PastShopping copyWith(
      {String? name, DateTime? time, List<Thing>? things, int? cost}) {
    return PastShopping(
      uuid: uuid,
      name: name ?? this.name,
      listUuid: listUuid,
      time: time ?? this.time,
      things: things ?? this.things,
      cost: cost ?? this.cost,
    );
  }
}

class ShoppingListsNotifier extends Notifier<List<ShoppingList>> {
  @override
  List<ShoppingList> build() {
    return [];
  }

  void addList(ShoppingList list) {
    state = [...state, list];
  }

  void removelist(String listUuid) {
    state = [
      for (var list in state)
        if (list.uuid != listUuid) list,
    ];
  }

  void editList(String listUuid, String? name, String? descripion) {
    state = [
      for (var list in state)
        if (list.uuid == listUuid)
          list.copyWith(name: name, description: descripion)
        else
          list
    ];
  }

  void addThing(String listUuid, Thing thing) {
    state = [
      for (var list in state)
        if (list.uuid == listUuid)
          list.copyWith(things: [...list.things, thing])
        else
          list
    ];
  }

  void removeThing(String listUuid, String thingUuid) {
    state = [
      for (var list in state)
        if (list.uuid == listUuid)
          list.copyWith(things: [
            for (var thing in list.things)
              if (thing.uuid != thingUuid) thing
          ])
        else
          list
    ];
  }

  void editThing(
      String listUuid, String thingUuid, String? name, bool? bought) {
    state = [
      for (var list in state)
        if (list.uuid == listUuid)
          list.copyWith(things: [
            for (var thing in list.things)
              if (thing.uuid == thingUuid)
                thing.copyWith(name: name, bought: bought)
              else
                thing
          ])
        else
          list
    ];
  }

  void addShopping(PastShopping shopping) {
    state = [
      for (var list in state)
        if (list.uuid == shopping.listUuid)
          list.copyWith(pastShoppings: [...list.pastShoppings, shopping])
        else
          list
    ];
  }
}

final shoppingListsProvider =
    NotifierProvider<ShoppingListsNotifier, List<ShoppingList>>(() {
  return ShoppingListsNotifier();
});
