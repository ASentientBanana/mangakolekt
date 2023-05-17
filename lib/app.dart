import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/theme/theme_bloc.dart';
import 'package:mangakolekt/models/bloc/theme.dart';
import 'package:mangakolekt/screens/lib.dart';
import 'package:mangakolekt/screens/reader.dart';
import 'package:mangakolekt/screens/setting.dart';
import 'package:mangakolekt/screens/splash.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      ThemeStore theme;
      if (state is ThemeLoaded) {
        theme = state.themes[state.theme];
      } else {
        theme = (state as ThemeInitial).themes[0];
      }
      return MaterialApp(
        title: 'MangaKolekt',
        theme: ThemeData(
          primaryColor: theme.primaryColor,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: theme.backgroundColor,
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: theme.appbarBackground,
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: theme.primaryColor,
            secondary: theme.accentColor,
            tertiary: theme.tertiary,
            brightness: Brightness.dark,
          ),
        ),

        // theme: convertToThemeData(theme),
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const MyHomePage(),
          '/reader': (context) => MangaReader(),
          '/settings': (context) => const SettingsPage(),
        },
      );
    });
  }
}
