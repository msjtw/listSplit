import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:uuid/uuid.dart';

@immutable
class Group {
  final String uid;
  final String name;
  final String description;
  final List<String> usersUids;
  final List<FirestoreShoppingList> shoppingLists;

  Group(
      {String? uid,
      String? name,
      String? description,
      List<String>? usersUids,
      List<FirestoreShoppingList>? shoppingLists})
      : uid = uid ?? nanoid(12),
        name = name ?? '',
        description = description ?? '',
        usersUids = usersUids ?? [],
        shoppingLists = shoppingLists ?? [];

  factory Group.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Group(
      uid: data?['uid'],
      name: data?['name'],
      description: data?['description'],
      usersUids:
          data?['usersUids'] is Iterable ? List.from(data?['usersUids']) : [],
      shoppingLists: data?['shoppingLists'] is Iterable
          ? List.from(data?['shoppingLists'])
              .map((shoppinglist) =>
                  FirestoreShoppingList.fromJson(shoppinglist))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "name": name,
      "description": description,
      "usersUids": usersUids,
      "shoppingLists": List<dynamic>.from(
        shoppingLists.map(
          (d) => d.toJson(),
        ),
      ),
    };
  }

  Group copyWith({
    String? uid,
    String? name,
    String? description,
    List<String>? usersUids,
    List<FirestoreShoppingList>? shoppingLists,
  }) {
    return Group(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      usersUids: usersUids ?? this.usersUids,
      shoppingLists: shoppingLists ?? this.shoppingLists,
    );
  }

  @override
  String toString() {
    return '(uid: $uid, name: $name, description: $description, usersUids: ${usersUids.length}) ';
  }
}

@immutable
class FirestoreThing {
  final String uid;
  final String name;
  final int listUuid;
  final bool bought;

  FirestoreThing(
      {required this.name,
      required this.bought,
      required this.listUuid,
      String? uid})
      : uid = uid ?? const Uuid().v4();

  factory FirestoreThing.fromJson(Map<String, dynamic> data) {
    return FirestoreThing(
      uid: data['uid'],
      name: data['name'],
      listUuid: data['listUuid'],
      bought: data['bought'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "listUuid": listUuid,
      "bought": bought,
    };
  }

  FirestoreThing copyWith(
      {String? uid, String? name, int? listUuid, bool? bought}) {
    return FirestoreThing(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      listUuid: listUuid ?? this.listUuid,
      bought: bought ?? this.bought,
    );
  }

  @override
  String toString() {
    return '(uid: $uid, name: $name, list uuid: $listUuid, bought: $bought) ';
  }
}

@immutable
class FirestoreShoppingList {
  final String uid;
  final List<FirestoreThing> things;
  final String name;
  final String description;
  final List<FirestorePastShopping> pastShoppings;

  FirestoreShoppingList({
    String? name,
    String? description,
    List<FirestoreThing>? things,
    String? uid,
    List<FirestorePastShopping>? pastShoppings,
  })  : name = name ?? '',
        description = description ?? 'List desctiption..',
        things = things ?? [],
        uid = uid ?? const Uuid().v4(),
        pastShoppings = pastShoppings ?? [];

  factory FirestoreShoppingList.fromJson(Map<String, dynamic> data) {
    return FirestoreShoppingList(
      uid: data['uid'],
      name: data['name'],
      description: data['description'],
      things: data['things'] is Iterable
          ? List.from(data['things'])
              .map((thing) => FirestoreThing.fromJson(thing))
              .toList()
          : [],
      pastShoppings: data['pastShoppings'] is Iterable
          ? List.from(data['pastShoppings'])
              .map((pastShopping) =>
                  FirestorePastShopping.fromJson(pastShopping))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "description": description,
      "FirestorePastShopping": List<dynamic>.from(
        pastShoppings.map(
          (d) => d.toJson(),
        ),
      ),
      "things": List<dynamic>.from(
        things.map(
          (d) => d.toJson(),
        ),
      ),
    };
  }

  FirestoreShoppingList copyWith({
    String? uid,
    List<FirestoreThing>? things,
    String? name,
    String? description,
    List<FirestorePastShopping>? pastShoppings,
  }) {
    return FirestoreShoppingList(
      uid: uid ?? this.uid,
      things: things ?? this.things,
      name: name ?? this.name,
      description: description ?? this.description,
      pastShoppings: pastShoppings ?? this.pastShoppings,
    );
  }

  @override
  String toString() {
    return '(uid: $uid, name: $name, things: ${things.length}, past shoppings: ${pastShoppings.length}) ';
  }
}

@immutable
class FirestorePastShopping {
  final String uid;
  final String name;
  final String listUuid;
  final DateTime time;
  final List<FirestoreThing> things;
  final double cost;

  FirestorePastShopping({
    required this.listUuid,
    List<FirestoreThing>? things,
    String? uid,
    String? name,
    DateTime? time,
    double? cost,
  })  : uid = uid ?? const Uuid().v4(),
        time = time ?? DateTime.now(),
        name = name ?? '',
        things = things ?? [],
        cost = cost ?? -1;

  factory FirestorePastShopping.fromJson(Map<String, dynamic> data) {
    return FirestorePastShopping(
      uid: data['uid'],
      name: data['name'],
      listUuid: data['listUuid'],
      time: data['time'],
      cost: data['cost'],
      things: data['things'] is Iterable
          ? List.from(data['things'])
              .map((thing) => FirestoreThing.fromJson(thing))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "listUuid": listUuid,
      "time": time,
      "cost": cost,
      "things": List<dynamic>.from(
        things.map(
          (d) => d.toJson(),
        ),
      ),
    };
  }

  FirestorePastShopping copyWith(
      {String? name,
      DateTime? time,
      List<FirestoreThing>? things,
      double? cost,
      String? uid}) {
    return FirestorePastShopping(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      listUuid: listUuid,
      time: time ?? this.time,
      things: things ?? this.things,
      cost: cost ?? this.cost,
    );
  }

  @override
  String toString() {
    return '(uid: $uid, name: $name, list uuid: $listUuid, things: ${things.length}, cost: $cost) ';
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
