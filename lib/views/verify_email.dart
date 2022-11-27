import 'package:flutter/material.dart';
import 'package:mynote/constants/routes.dart';
import 'package:mynote/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(children: [
        const Text('We have send an email verification. Please open it to verify your account'),
        const Text('If you have not received your verification email, please press the button below'),
        TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send email verification')),
        TextButton(onPressed: () async {
          await AuthService.firebase().logout();
          await Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
        }, child: const Text('Restart'))
      ]),
    );
  }
}
