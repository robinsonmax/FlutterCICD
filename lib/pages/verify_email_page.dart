import 'dart:async';

import 'package:flutter/material.dart';

import '../auth.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  void initState() {
    // As non of the auth streams subscribe to the user.emailVerified changing,
    // I'm just making it reload the user every 5 secs to check 🤮
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await Auth().reloadUser();
      if (Auth().currentUser!.emailVerified) {
        timer.cancel();
      }
    });

    super.initState();
  }

  resendVerification() {
    Auth().currentUser?.sendEmailVerification();
    const snackBar = SnackBar(content: Text('Email Sent'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Please tap the link in the email we\'ve just sent you.'),
            const Text('Didn\'t get the email?.'),
            ElevatedButton(
              onPressed: resendVerification,
              child: const Text('Resend Email'),
            ),
            TextButton(
              onPressed: () {
                Auth().signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
