import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/theme/theme_bloc.dart';
import 'package:mangakolekt/models/bloc/theme.dart';
import 'package:mangakolekt/screens/lib.dart';
import 'package:mangakolekt/screens/reader.dart';
import 'package:mangakolekt/screens/setting.dart';
import 'package:mangakolekt/screens/splash.dart';
import 'package:mangakolekt/screens/theme_creator.dart';
import 'package:mangakolekt/util/theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      ThemeStore theme = state is ThemeLoaded
          ? state.themes[state.theme]
          : (state as ThemeInitial).themes[0];
      return MaterialApp(
        title: 'MangaKolekt',
        theme: convertToThemeData(theme),
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const MyHomePage(),
          '/reader': (context) => MangaReader(),
          '/settings': (context) => const SettingsPage(),
          '/theme_creator': (context) => const ThemeCreatorPage(),
        },
      );
    });
  }
}
