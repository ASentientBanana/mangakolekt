import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/screens/library.dart';
import 'package:mangakolekt/screens/mobile/bookmarks.dart';
import 'package:mangakolekt/screens/mobile/createLib.dart';
import 'package:mangakolekt/screens/mobile/grid.dart';
import 'package:mangakolekt/screens/mobile/library.dart';
import 'package:mangakolekt/screens/mobile/settings.dart';
import 'package:mangakolekt/screens/splash.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:mangakolekt/screens/readerPageWrapper.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  static const defaultTextStyle = TextStyle(
      fontFamily: "HighlandGothic", color: Color.fromARGB(255, 238, 245, 238));

  Route<Widget>? onRouteGenerateHandler(RouteSettings settings) {
    switch (settings.name) {
      case '/reader':
        final args = (settings.arguments as Map<String, dynamic>);
        return pageRouteBuilderWrapper(
            settings,
            ReaderPageWrapper(
              initialPage: args['initialPage'],
              path: args["path"],
              id: args["id"],
            ));
      case "/home":
        return pageRouteBuilderWrapper(
            settings,
            (Platform.isAndroid || Platform.isIOS)
                ? const MyHomePageMobile()
                : const MyHomePage());
      case "/":
        return pageRouteBuilderWrapper(settings, const SplashScreen());
      case "/settings":
        // return DialogRoute(context: , builder: builder)
        return pageRouteBuilderWrapper(settings, const SettingsMobile());
      case "/help":
        // return DialogRoute(context: , builder: builder)
        return pageRouteBuilderWrapper(settings, const SettingsMobile());
        break;
      case "/bookmarks":
        // return DialogRoute(context: , builder: builder)
        return pageRouteBuilderWrapper(settings, BookmarksMobile());
      case "/grid":
        return pageRouteBuilderWrapper(settings, const MobileGreedScreen());
      case "/addLibrary":
        final args = (settings.arguments as Map<String, dynamic>);
        return pageRouteBuilderWrapper(
            settings, CreateLibraryMobile(path: args['path']));

      default:
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MangaKolekt',
      theme: ThemeData().copyWith(
        // canvasColor: Colors.red,
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: const MaterialStatePropertyAll(
            Color(0xFFc1cc9c),
          ),
        ),
        appBarTheme: const AppBarTheme(),
        textTheme:
            Typography().dense.apply(fontFamily: "HighlandGothic").copyWith(
                  titleMedium: defaultTextStyle,
                  titleLarge: defaultTextStyle,
                  displayLarge: defaultTextStyle,
                  displayMedium: defaultTextStyle,
                  bodyLarge: defaultTextStyle,
                  bodyMedium: defaultTextStyle,
                ),
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: MangaColors.primary,
          onPrimary: Color(0xFFeef5ee),
          secondary: Color(0xFFb5d1f1),
          onSecondary: Color(0xFFc1cc9c),
          error: MangaColors.primary,
          onError: Color(0xFFc1cc9c),
          background: MangaColors.background,
          onBackground: MangaColors.background,
          surface: Color(0xFF081822),
          onSurface: Color(0xFFeef5ee),
          tertiary: Color(0xFFc1cc9c),
        ),
      ),
      // theme: convertToThemeData(theme),
      //Using this to remove a transition effect from the default i get when using routes:{}
      onGenerateRoute: onRouteGenerateHandler,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
