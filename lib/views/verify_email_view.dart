import 'package:flutter/material.dart';
import 'package:privatenotes/constants/routes.dart';
import 'package:privatenotes/services/auth/auth_service.dart';

class VeryfyEmailView extends StatefulWidget {
  const VeryfyEmailView({super.key});

  @override
  State<VeryfyEmailView> createState() => _VeryfyEmailViewState();
}

class _VeryfyEmailViewState extends State<VeryfyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(
          children: [
            const Text("We've send you verifaction code blah blah"),
            const Text("If you haven't recived verification email yet blah blah"),
            TextButton(
                onPressed: () async {
                 await AuthService.firebase().sendEmailVerification();
                },
                child: const Text('Send veryfecation email')),
            TextButton(onPressed: () async {
              await AuthService.firebase().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            }, child: const Text("Restart"))
          ],
        ),
    );
  }
}