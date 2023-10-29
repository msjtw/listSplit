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

  // Remove a Movie
//   Future<bool> removeMovie(String movieId) async {
//     _movies = _firestore.collection('movies');
//     try {
//       await _movies
//           .doc(movieId)
//           .delete(); // deletes the document with id of movieId from our movies collection
//       return true; // return true after successful deletion .
//     } catch (e) {
//       print(e.message);
//       return Future.error(e); // return error
//     }
//   }

// Edit a Movie
//   Future<bool> editGroup(G, String movieId) async {
//     _movies = _firestore.collection('movies');
//     try {
//       await _movies
//           .doc(movieId)
//           .update(// updates the movie document having id of moviedId
//               {'name': m.movieName, 'poster': m.posterURL, 'length': m.length});
//       return true; //// return true after successful updation .
//     } catch (e) {
//       print(e.message);
//       return Future.error(e); //return error
//     }
//   }
}
