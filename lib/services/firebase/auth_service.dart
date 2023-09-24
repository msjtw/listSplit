import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in anon

  Future anonSingIn() async {
    print('dotarlo');
    try {
      var result = await _auth.signInAnonymously();
      var user = result.user;
      print(user);
      print('object');
      return user;
    } catch (e) {
      return null;
    }
  }

  //sign in email
}
