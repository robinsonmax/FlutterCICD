import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_cicd_testing/pages/loading_page.dart';
import 'package:flutter_cicd_testing/routers/auth_router.dart';

import 'pages/error_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorPage(
              issue: 'Failed to start Firebase',
              details: snapshot.error.toString(),
            );
          } else if (snapshot.hasData) {
            return const AuthRouter();
          } else {
            return const LoadingPage();
          }
        },
      ),
    );
  }
}
