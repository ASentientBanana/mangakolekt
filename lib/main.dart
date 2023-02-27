import 'package:flutter/material.dart';
import 'package:mangakolekt/screens/lib.dart';
import 'package:mangakolekt/screens/training/TrainingPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: {
        '/': (context) => TrainingPage(),
      },
    );
  }
}
