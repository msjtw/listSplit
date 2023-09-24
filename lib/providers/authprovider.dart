import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:list_split/main.dart';

class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  void anonSingIn() async {
    print('a tu');
    state = await firebaseAuth.anonSingIn();
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(() {
  return UserNotifier();
});
