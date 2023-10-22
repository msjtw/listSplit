import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Group {
  final String uid;
  final String name;
  final String description;
  final List<String>? usersUids;
  final List<String>? things;

  Group(
      {String? uid,
      String? name,
      String? description,
      this.usersUids,
      this.things})
      : uid = uid ?? const Uuid().v4(),
        name = name ?? 'name',
        description = description ?? '';

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
      if (usersUids != null) "usersUids": usersUids,
      if (things != null) "things": things,
    };
  }
}
