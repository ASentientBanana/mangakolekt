import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/screens/lib.dart';
import 'package:mangakolekt/screens/reader.dart';
import 'package:mangakolekt/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

// TODO: Posibly move this to a init state later? It may be called too much.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibBloc(),
      child: MaterialApp(
        title: 'MangaKolekt',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const MyHomePage(),
          '/reader': (context) => MangaReader(),
          // '/reader': (context) =>
        },
      ),
    );
  }
}
