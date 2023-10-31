import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/authprovider.dart';
import 'package:list_split/services/bnb.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordController2;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordController2 = TextEditingController();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('re-enter password'),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _passwordController2,
                    decoration: const InputDecoration(
                      labelText: 're-enter password',
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
                      if (_passwordController.text ==
                          _passwordController2.text) {
                        ref
                            .read(firebaseAuthProvider)
                            .registerWithEmailAndPassword(
                                _loginController.text, _passwordController.text)
                            .then(
                          (user) {
                            ref
                                .read(firebaseAuthProvider)
                                .signInWithEmailAndPassword(
                                    _loginController.text,
                                    _passwordController.text)
                                .then(
                              (value) {
                                Navigator.of(context).pop();
                              },
                            ).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                              return null;
                            });
                          },
                        ).onError(
                          (error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                            return null;
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("passwords don't match"),
                          ),
                        );
                      }
                    },
                    child: const Text('register'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
