import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/firestore_models.dart';

class FirestoreDB {
  FirestoreDB(this._firestore);
  final FirebaseFirestore _firestore;

  Stream<QuerySnapshot> get allGroups {
    return _firestore.collection("groups").snapshots();
  }

  Stream<QuerySnapshot<Group>> userGroups(String userUid) {
    return _firestore
        .collection("groups")
        .withConverter(
            fromFirestore: Group.fromFirestore,
            toFirestore: (Group group, _) => group.toFirestore())
        .where("usersUids", arrayContains: userUid)
        .snapshots();
  }

  Stream<QuerySnapshot<FirestorePastShopping>> allGroupShoppings(
      String groupUid) {
    return _firestore
        .collection("groups")
        .doc(groupUid)
        .collection('pastShoppings')
        .withConverter(
            fromFirestore: FirestorePastShopping.fromFirestore,
            toFirestore: (FirestorePastShopping shopping, _) =>
                shopping.toFirestore())
        .snapshots();
  }

  Stream<DocumentSnapshot<Group>> getGroup(String groupUid) {
    return _firestore
        .collection("groups")
        .withConverter(
            fromFirestore: Group.fromFirestore,
            toFirestore: (Group group, _) => group.toFirestore())
        .doc(groupUid)
        .snapshots();
  }

  Future<bool> addNewGroup(Group group) async {
    final ref = _firestore.collection("groups").withConverter(
        fromFirestore: Group.fromFirestore,
        toFirestore: (Group group, _) => group.toFirestore());
    try {
      await ref.doc(group.uid).set(group);
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> addUserToGroup(User user, String groupUid) async {
    final ref = _firestore.collection("groups").doc(groupUid).withConverter(
        fromFirestore: Group.fromFirestore,
        toFirestore: (Group group, _) => group.toFirestore());
    final groupSnap = await ref.get();
    final group = groupSnap.data();
    if (group == null) {
      return Future.error('group not found');
    }
    if (group.usersUids.contains(user.uid)) {
      return Future.error('user already in group');
    }
    try {
      await ref.update({
        'usersUids': FieldValue.arrayUnion([user.uid])
      });
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> leaveGroup(User user, String groupUid) async {
    final ref = _firestore.collection("groups").doc(groupUid).withConverter(
        fromFirestore: Group.fromFirestore,
        toFirestore: (Group group, _) => group.toFirestore());
    final groupSnap = await ref.get();
    final group = groupSnap.data();
    if (group == null) {
      return Future.error('group not found');
    }
    try {
      await ref.update({
        'usersUids': FieldValue.arrayRemove([user.uid])
      });
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> addThing(String groupUid, FirestoreThing thing) async {
    final ref = _firestore.collection("groups").doc(groupUid).withConverter(
        fromFirestore: Group.fromFirestore,
        toFirestore: (Group group, _) => group.toFirestore());
    try {
      await ref.update({
        'things': FieldValue.arrayUnion([thing.toJson()])
      });
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> removeThing(String groupUid, FirestoreThing thing) async {
    final ref = _firestore.collection("groups").doc(groupUid).withConverter(
        fromFirestore: Group.fromFirestore,
        toFirestore: (Group group, _) => group.toFirestore());
    try {
      await ref.update({
        'things': FieldValue.arrayRemove([thing.toJson()])
      });
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> updateThing(
      Group group, FirestoreThing oldThing, FirestoreThing newThing) async {
    final ref = _firestore.collection("groups").doc(group.uid).withConverter(
        fromFirestore: Group.fromFirestore,
        toFirestore: (Group group, _) => group.toFirestore());
    try {
      await ref.update({
        'things': FieldValue.arrayRemove([oldThing.toJson()])
      });
      await ref.update({
        'things': FieldValue.arrayUnion([newThing.toJson()])
      });
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> updateAllThings(Group group, List<FirestoreThing> things) async {
    final ref = _firestore.collection("groups").doc(group.uid).withConverter(
        fromFirestore: Group.fromFirestore,
        toFirestore: (Group group, _) => group.toFirestore());
    try {
      await ref.update({
        'things': List<dynamic>.from(
          things.map(
            (d) => d.toJson(),
          ),
        )
      });
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> setPastShopping(FirestorePastShopping shopping) async {
    final ref = _firestore
        .collection("groups")
        .doc(shopping.groupUid)
        .collection('pastShoppings')
        .withConverter(
            fromFirestore: FirestorePastShopping.fromFirestore,
            toFirestore: (FirestorePastShopping shopping, _) =>
                shopping.toFirestore());
    try {
      if (shopping.things.isNotEmpty) {
        await ref.doc(shopping.uid).set(shopping);
      } else {
        await ref.doc(shopping.uid).delete();
      }
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }
}
