import 'package:flutter/material.dart';
import 'package:flutter_cicd_testing/pages/error_page.dart';
import 'package:flutter_cicd_testing/pages/home_page.dart';
import 'package:flutter_cicd_testing/pages/loading_page.dart';
import 'package:flutter_cicd_testing/pages/login_register_page.dart';
import 'package:flutter_cicd_testing/pages/verify_email_page.dart';

import '../auth.dart';

class AuthRouter extends StatefulWidget {
  const AuthRouter({super.key});

  @override
  State<AuthRouter> createState() => _AuthRouterState();
}

class _AuthRouterState extends State<AuthRouter> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().userChanges,
      builder: (context, snapshot) {
        debugPrint("Auth State Change:");
        debugPrint(context.toString());

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else if (snapshot.hasError) {
          return ErrorPage(
              issue: 'Error when loading user',
              details: snapshot.error.toString());
        } else if (!snapshot.hasData) {
          return const LoginPage();
        }

        debugPrint("Auth Snapshot Data:");
        debugPrint(snapshot.data.toString());
        if (snapshot.data!.emailVerified) {
          return const MyHomePage(title: 'Flutter Demo');
        } else if (Auth().currentUser != null) {
          return const VerifyEmailPage();
        } else {
          return const ErrorPage(
            issue: 'Couldn\'t find user',
            details:
                'When authenticating the user, snapshot data was provided, but the currentuser was null.',
          );
        }
      },
    );
  }
}
