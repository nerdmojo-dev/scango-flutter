import 'package:flutter/material.dart';
import 'package:scango/pages/DUMMY/new_home.dart';
import 'package:scango/pages/DUMMY/new_sign.dart';
import 'package:scango/pages/signin/signin.dart';
import 'package:scango/pages/signin/student.dart';
import 'package:scango/pages/signup/signup.dart';
import 'package:scango/pages/pages.dart';
import 'package:scango/pages/homepage/homepage_student.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure plugin initialization
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SignUpPage(),
        // '/home': (context) => HomePage(),
      },
    );
  }
}
