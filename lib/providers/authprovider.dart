import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:list_split/services/firebase/auth_service.dart';

// provider to access the FirebaseAuth instance
final firebaseAuthProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(firebaseAuthProvider).authStateChange;
});
