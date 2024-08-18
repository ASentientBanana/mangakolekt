import 'package:flutter/material.dart';
import 'package:mangakolekt/app.dart';
import 'package:mangakolekt/locator.dart';

void main() {
  // Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  runApp(const MyApp());
}
// multy threaded Vagabond :: 327 books ~30s
// single threaded Vagabond :: 327 books ~30s

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppWidget();
  }
}
