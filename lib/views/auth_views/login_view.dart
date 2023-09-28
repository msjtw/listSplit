import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/authprovider.dart';
import 'package:list_split/services/bnb.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      bottomNavigationBar: const BNB(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('email'),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _loginController,
                    decoration: const InputDecoration(
                      labelText: 'email',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('password'),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'password',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    maxLines: 1,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
                          _loginController.text, _passwordController.text);
                    },
                    child: const Text('log in '),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text("Don't have account?"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.badge_outlined),
                      label: const Text('create one ')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
