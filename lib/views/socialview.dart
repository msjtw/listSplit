import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/authprovider.dart';
import 'package:list_split/views/auth_views/login_view.dart';
import 'package:list_split/views/splash_view.dart';

import '../services/bnb.dart';

class AuthStateCheck extends ConsumerWidget {
  const AuthStateCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) return SocialView(user);
        return const LoginView();
      },
      error: (error, stackTrace) => const LoginView(),
      loading: () => const SplashView(),
    );
  }
}

class SocialView extends ConsumerStatefulWidget {
  const SocialView(this.user, {super.key});

  final User user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SocialViewState();
}

class _SocialViewState extends ConsumerState<SocialView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your groups'),
          actions: [
            IconButton(
                onPressed: () => ref.read(firebaseAuthProvider).signOut(),
                icon: const Icon(Icons.logout))
          ],
        ),
        bottomNavigationBar: const BNB(),
        body: Center(
          child: Text(widget.user.uid),
        ));
  }
}
