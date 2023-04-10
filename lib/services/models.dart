import 'package:flutter/material.dart';
import 'package:notes_app/services/fasthash.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

@Entity()
@immutable
class Thing {
  @Id(assignable: true)
  int uuid;
  final String name;
  final int listUuid;
  final bool bought;

  final list = ToOne<ShoppingList>();

  Thing({
    required this.name,
    required this.bought,
    required this.listUuid,
    int? uuid,
  }) : uuid = uuid ?? 0;

  Thing copyWith({int? uuid, String? name, int? listUuid, bool? bought}) {
    return Thing(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      listUuid: listUuid ?? this.listUuid,
      bought: bought ?? this.bought,
    );
  }
}

@Entity()
@immutable
class ShoppingList {
  @Id()
  int uuid;
  @Transient()
  final List<Thing> things;
  final String name;
  final String description;
  @Transient()
  final List<PastShopping> pastShoppings;

  ShoppingList({
    required this.name,
    String? description,
    List<Thing>? things,
    int? uuid,
    List<PastShopping>? pastShoppings,
    int? obId,
  })  : description = description ?? 'List desctiption..',
        things = things ?? [],
        uuid = uuid ?? 0,
        pastShoppings = pastShoppings ?? [];

  ShoppingList copyWith({
    int? uuid,
    List<Thing>? things,
    String? name,
    String? description,
    List<PastShopping>? pastShoppings,
  }) {
    return ShoppingList(
      uuid: uuid ?? this.uuid,
      things: things ?? this.things,
      name: name ?? this.name,
      description: description ?? this.description,
      pastShoppings: pastShoppings ?? this.pastShoppings,
    );
  }
}

@Entity()
@immutable
class PastShopping {
  @Id()
  int uuid;
  final String name;
  final int listUuid;
  @Property(type: PropertyType.date)
  final DateTime time;
  @Transient()
  final List<Thing> things;
  final int cost;

  PastShopping({
    required this.listUuid,
    List<Thing>? things,
    int? uuid,
    String? name,
    DateTime? time,
    int? cost,
    int? obId,
  })  : uuid = uuid ?? 0,
        time = time ?? DateTime.now(),
        name = name ?? '',
        things = things ?? [],
        cost = cost ?? -1;

  PastShopping copyWith(
      {String? name,
      DateTime? time,
      List<Thing>? things,
      int? cost,
      int? uuid}) {
    return PastShopping(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      listUuid: listUuid,
      time: time ?? this.time,
      things: things ?? this.things,
      cost: cost ?? this.cost,
    );
  }
}
