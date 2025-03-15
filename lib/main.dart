import 'package:flutter/material.dart';
import 'package:scango/pages/signup/signup.dart';
import 'package:scango/pages/pages.dart';

void main() {
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
        '/home': (context) => HomePage(),
      },
    );
  }
}
