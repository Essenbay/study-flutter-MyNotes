import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynote/constants/routes.dart';

import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter your email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(myNoteRoute, (route) => false);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    devtools.log("Weak Password");
                  } else if (e.code == 'email-already-in-use') {
                    devtools.log("Email already in use");
                  } else if (e.code == 'invalid-email') {
                    devtools.log("Invalid Email");
                  } else {
                    devtools.log(e.runtimeType.toString());
                    devtools.log(e.toString());
                  }
                } catch (e) {
                  devtools.log("Something had happened...");
                  devtools.log(e.runtimeType.toString());
                  devtools.log(e.toString());
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already have an account? Login here'))
        ],
      ),
    );
  }
}
