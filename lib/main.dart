import 'package:chatmate/Views/SplashScreen.dart';
import 'package:chatmate/themes/AppTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  print('firebase app = ${firebaseApp.name} ${firebaseApp.options.projectId}');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:  AppTheme().loadTheme(true),
      home: SplashScreen(),
    );
  }
}

