import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mangakolekt/app.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/store/library.dart';

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
