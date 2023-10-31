import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:uuid/uuid.dart';

@immutable
class FirestoreUser {
  final String uid;
  final String username;
  final List<String> lists;

  FirestoreUser({required this.uid, String? username, List<String>? lists})
      : username = username ?? '',
        lists = lists ?? [];

  factory FirestoreUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return FirestoreUser(
      uid: data?['uid'],
      username: data?['username'],
      lists: data?['lists'] is Iterable ? List.from(data?['lists']) : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "username": username,
      "lists": lists,
    };
  }

  FirestoreUser copyWith({
    String? uid,
    String? username,
    List<String>? lists,
  }) {
    return FirestoreUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      lists: lists ?? this.lists,
    );
  }

  @override
  String toString() {
    return '(uid: $uid, username: $username, lists: ${lists.length}) ';
  }
}

@immutable
class Group {
  final String uid;
  final String name;
  final String description;
  final List<String> usersUids;
  final List<FirestoreThing> things;

  Group(
      {String? uid,
      String? name,
      String? description,
      List<String>? usersUids,
      List<FirestoreThing>? things})
      : uid = uid ?? nanoid(12),
        name = name ?? '',
        description = description ?? '',
        usersUids = usersUids ?? [],
        things = things ?? [];

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
      things: data?['things'] is Iterable
          ? List.from(data?['things'])
              .map((thing) => FirestoreThing.fromJson(thing))
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
      "things": List<dynamic>.from(
        things.map(
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
    List<FirestoreThing>? things,
  }) {
    return Group(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      usersUids: usersUids ?? this.usersUids,
      things: things ?? this.things,
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
  final String groupUid;
  final bool bought;

  FirestoreThing(
      {required this.name,
      required this.bought,
      required this.groupUid,
      String? uid})
      : uid = uid ?? const Uuid().v4();

  factory FirestoreThing.fromJson(Map<String, dynamic> data) {
    return FirestoreThing(
      uid: data['uid'],
      name: data['name'],
      groupUid: data['groupUid'],
      bought: data['bought'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "groupUid": groupUid,
      "bought": bought,
    };
  }

  FirestoreThing copyWith(
      {String? uid, String? name, String? groupUid, bool? bought}) {
    return FirestoreThing(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      groupUid: groupUid ?? this.groupUid,
      bought: bought ?? this.bought,
    );
  }

  @override
  String toString() {
    return '(uid: $uid, name: $name, groupUid: $groupUid, bought: $bought) ';
  }
}

@immutable
class FirestorePastShopping {
  final String uid;
  final String name;
  final String groupUid;
  final DateTime time;
  final List<FirestoreThing> things;
  final double cost;

  FirestorePastShopping({
    required this.groupUid,
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

  factory FirestorePastShopping.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return FirestorePastShopping(
      uid: data?['uid'],
      name: data?['name'],
      groupUid: data?['groupUid'],
      time: data?['time'].toDate(),
      cost: data?['cost'].toDouble(),
      things: data?['things'] is Iterable
          ? List.from(data?['things'])
              .map((thing) => FirestoreThing.fromJson(thing))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "name": name,
      "groupUid": groupUid,
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
      groupUid: groupUid,
      time: time ?? this.time,
      things: things ?? this.things,
      cost: cost ?? this.cost,
    );
  }

  @override
  String toString() {
    return '(uid: $uid, name: $name, groupUid: $groupUid, things: ${things.length}, cost: $cost) ';
  }
}
