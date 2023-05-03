import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';
import 'package:mangakolekt/screens/lib.dart';
import 'package:mangakolekt/screens/reader.dart';
import 'package:mangakolekt/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEAC57D);
    const accentColor = Color(0xFF7B7C81);
    const backgroundColor = Color(0xFF1D0F0F);
    const primaryDark = Color(0xFF7B586B);
    const tertiary = Color(0xFF453C41);
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReaderBloc>(
            create: (BuildContext context) => ReaderBloc()),
        BlocProvider<LibraryBloc>(
            create: (BuildContext context) => LibraryBloc()),
      ],
      child: MaterialApp(
        title: 'MangaKolekt',
        theme: ThemeData(
          primaryColor: primaryColor,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: backgroundColor,
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryDark,
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: primaryColor,
              secondary: accentColor,
              tertiary: tertiary,
              brightness: Brightness.dark),
        ),
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const MyHomePage(),
          '/reader': (context) => MangaReader(),
        },
      ),
    );
  }
}
