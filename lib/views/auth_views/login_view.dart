import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/authprovider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your expenses'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(userProvider.notifier).anonSingIn;
            var user = ref.read(userProvider);
            if (user != null) {
              Navigator.pop(context);
            } else {
              print(user);
            }
          },
          child: const Text('log in anon'),
        ),
      ),
    );
  }
}
