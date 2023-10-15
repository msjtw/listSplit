import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String? uid;
  final String? name;
  final List<String>? usersUids;
  final List<String>? things;

  Group({this.uid, this.name, this.usersUids, this.things});

  factory Group.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Group(
      uid: data?['uid'],
      name: data?['name'],
      usersUids:
          data?['usersUids'] is Iterable ? List.from(data?['usersUids']) : null,
      things: data?['things'] is Iterable ? List.from(data?['things']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (name != null) "name": name,
      if (usersUids != null) "usersUids": usersUids,
      if (things != null) "things": things,
    };
  }
}
