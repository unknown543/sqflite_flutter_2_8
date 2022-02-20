import 'package:flutter/material.dart';

import './di.dart';
import './screen/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqflite Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          border: UnderlineInputBorder(),
          prefixIconColor: Colors.black,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 14.0,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
