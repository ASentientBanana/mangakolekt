import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/theme/theme_bloc.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/bloc/theme.dart';
import 'package:mangakolekt/screens/lib.dart';
import 'package:mangakolekt/screens/setting.dart';
import 'package:mangakolekt/screens/splash.dart';
import 'package:mangakolekt/screens/theme_creator.dart';
import 'package:mangakolekt/services/navigation_service.dart';
import 'package:mangakolekt/util/theme.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:mangakolekt/widgets/reader/reader_page_wrapper.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  Route<Widget>? onRouteGenerateHandler(RouteSettings settings) {
    switch (settings.name) {
      case '/reader':
        final args = (settings.arguments as Map<String, dynamic>);
        return pageRouteBuilderWrapper(
            settings,
            ReaderPageWrapper(
              path: args["path"],
              id: args["id"],
            ));
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
    return MaterialApp(
      title: 'MangaKolekt',
      theme: ThemeData().copyWith(
        // canvasColor: Colors.red,
        scrollbarTheme: ScrollbarThemeData().copyWith(
          thumbColor: const MaterialStatePropertyAll(
            Color(0xFFc1cc9c),
          ),
        ),
        appBarTheme: AppBarTheme(),
        textTheme:
            Typography().dense.apply(fontFamily: "HighlandGothic").copyWith(),

        // textTheme: Typography()
        //     .englishLike
        //     .apply(fontFamily: "HighlandGothic")
        //     .copyWith(
        //       bodyMedium: const TextStyle(
        //         color: Color(0xFFc1cc9c),
        //       ),
        //     ),
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF244769),
          onPrimary: Color(0xFFeef5ee),
          secondary: Color(0xFFb5d1f1),
          onSecondary: Color(0xFFc1cc9c),
          error: Color(0xFF244769),
          onError: Color(0xFFc1cc9c),
          background: Color(0xFF081822),
          onBackground: Color(0xFFeef5ee),
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
