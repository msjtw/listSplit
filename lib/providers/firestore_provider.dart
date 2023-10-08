import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/services/firebase/firestore.dart';

final firestoreProvider = Provider<FirestoreDB>((ref) {
  return FirestoreDB(FirebaseFirestore.instance);
});

final groupsProvider = StreamProvider<QuerySnapshot>((ref) {
  return ref.read(firestoreProvider).allGroups;
});
