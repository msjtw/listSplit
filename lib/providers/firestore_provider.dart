import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/services/firebase/firestore.dart';
import 'package:list_split/services/models/firestore_models.dart';

final firestoreProvider = Provider<FirestoreDB>((ref) {
  return FirestoreDB(FirebaseFirestore.instance);
});

final allGroupsProvider = StreamProvider<QuerySnapshot>((ref) {
  return ref.read(firestoreProvider).allGroups;
});

final userGroupsProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<Group>, String>((ref, String userUid) {
  return ref.read(firestoreProvider).userGroups(userUid);
});

final groupProvider = StreamProvider.autoDispose
    .family<DocumentSnapshot<Group>, String>((ref, String groupUid) {
  return ref.read(firestoreProvider).getGroup(groupUid);
});

// final userName = Provider.autoDispose.family<FirestoreDB, String>((ref, String uid) {
//   return ref.read(firestoreProvider).userName(uid);
// });

