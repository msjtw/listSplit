import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
class Group {
  final String uid;
  final String name;
  final String description;
  final List<String> usersUids;
  final List<String> things;

  Group(
      {String? uid,
      String? name,
      String? description,
      List<String>? usersUids,
      List<String>? things})
      : uid = uid ?? const Uuid().v4(),
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
          data?['usersUids'] is Iterable ? List.from(data?['usersUids']) : null,
      things: data?['things'] is Iterable ? List.from(data?['things']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "name": name,
      "description": description,
      "usersUids": usersUids,
      "things": things,
    };
  }

  Group copyWith({
    String? uid,
    String? name,
    String? description,
    List<String>? usersUids,
    List<String>? things,
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
