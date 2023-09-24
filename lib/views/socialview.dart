import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/authprovider.dart';
import 'package:list_split/views/auth_views/login_view.dart';

import '../services/bnb.dart';

class SocialView extends ConsumerStatefulWidget {
  const SocialView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SocialViewState();
}

class _SocialViewState extends ConsumerState<SocialView> {
  // if (user == null) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => const LoginView(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    User? user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groups'),
      ),
      bottomNavigationBar: const BNB(),
      body: user != null ? socialView(context, user) : loginView(context),
    );
  }

  Widget loginView(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
              );
            },
            child: const Text('log in'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('create account'),
          ),
        ],
      ),
    );
  }

  Widget socialView(context, user) {
    return Container();
  }
}
