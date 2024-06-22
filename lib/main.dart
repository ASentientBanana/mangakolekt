import 'package:flutter/material.dart';
import 'package:mangakolekt/app.dart';
import 'package:mangakolekt/locator.dart';

void main() {
  // Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppWidget();
  }
}
