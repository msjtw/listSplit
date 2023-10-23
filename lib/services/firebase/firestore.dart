import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<bool> addNewGroup(Group group) async {
    final ref = _firestore.collection("groups").withConverter(
        fromFirestore: Group.fromFirestore,
        toFirestore: (Group group, _) => group.toFirestore());
    try {
      await ref.add(group);
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> addUserToGroup(String userUid, String groupUid) async {
    CollectionReference userToGroup = _firestore.collection('userToGroup');
    try {
      await userToGroup.add(
        {
          'user': userUid,
          'group': groupUid,
        },
      );
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

// // Edit a Movie
//   Future<bool> editMovie(Movie m, String movieId) async {
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
