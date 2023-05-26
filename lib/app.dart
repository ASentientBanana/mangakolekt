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
import 'package:mangakolekt/util/util.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  Route<Widget>? onRouteGenerateHandler(RouteSettings settings) {
    switch (settings.name) {
      case '/reader':
        return pageRouteBuilderWrapper(settings, const MangaReader());
      case "/home":
        return pageRouteBuilderWrapper(settings, const MyHomePage());
      case "/":
        return pageRouteBuilderWrapper(settings, const SplashScreen());
      case "/settings":
        return pageRouteBuilderWrapper(settings, const SettingsPage());
      case "/theme_creator":
        return pageRouteBuilderWrapper(settings, const ThemeCreatorPage());
      default:
        break;
    }
    if (settings.name == '/reader') {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      ThemeStore theme = state is ThemeLoaded
          ? state.themes[state.theme]
          : (state as ThemeInitial).themes[0];
      return MaterialApp(
        title: 'MangaKolekt',
        theme: convertToThemeData(theme),
        //Using this to remove a transition effect from the default i get when using routes:{}
        onGenerateRoute: onRouteGenerateHandler,
      );
    });
  }
}
