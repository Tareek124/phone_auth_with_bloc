import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants/strings.dart';
import 'routes.dart';

String? initialRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      initialRoute = phoneNumberScreen;
    } else {
      initialRoute = mapsScreen;
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  AppRoutes appRoutes = AppRoutes();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Phone Auth With Bloc",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRoutes.route,
      initialRoute: initialRoute,
    );
  }
}
