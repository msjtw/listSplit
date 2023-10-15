import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/authprovider.dart';
import 'package:list_split/providers/firestore_provider.dart';
import 'package:list_split/views/auth_views/login_view.dart';

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
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
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
    final groupList = ref.watch(groupsProvider);

    ref.watch(firestoreProvider).userGroups(widget.user.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groups'),
        actions: [
          IconButton(
              onPressed: () => showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Your account'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("You' logged as: \n${widget.user.email}"),
                          const Text("Do you want to log out?"),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  ).then((res) {
                    if (res == true) {
                      ref.read(firebaseAuthProvider).signOut();
                    }
                  }),
              icon: const Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: const BNB(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            ref.read(firestoreProvider).addNewGroup(widget.user.uid),
        label: const Text('New List'),
        icon: const Icon(Icons.add),
      ),
      body: groupList.when(
        data: (data) {
          return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Text('${data.docs[index].id}');
              });
        },
        error: (error, stackTrace) => const Center(
          child: Text('Uh oh. Something went wrong!'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
