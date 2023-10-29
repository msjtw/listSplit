import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  const AuthService(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  User? get getUser => _auth.currentUser;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<User?> signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return Future.error(e);
    }
  }
}
