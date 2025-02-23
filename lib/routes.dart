import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:mangakolekt/screens/library.dart';
import 'package:mangakolekt/screens/mobile/bookmarks.dart';
import 'package:mangakolekt/screens/mobile/createLib.dart';
import 'package:mangakolekt/screens/mobile/grid.dart';
import 'package:mangakolekt/screens/mobile/help.dart';
import 'package:mangakolekt/screens/mobile/library.dart';
import 'package:mangakolekt/screens/mobile/settings.dart';
import 'package:mangakolekt/screens/splash.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:mangakolekt/screens/readerPageWrapper.dart';

// This is unused currently
class MangaRoutes {
  // MangaRoutes({required this.settings});

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
            libraryId: args['libraryId'],
          ),
        );
      case "/home":
        return pageRouteBuilderWrapper(settings,
            (isMobile()) ? const MyHomePageMobile() : const MyHomePage());
      case "/":
        return pageRouteBuilderWrapper(settings, const SplashScreen());
      case "/settings":
        // return DialogRoute(context: , builder: builder)
        return pageRouteBuilderWrapper(settings, const SettingsMobile());
      case "/help":
        // return DialogRoute(context: , builder: builder)
        return pageRouteBuilderWrapper(settings, HelpScreenMobile());
      case "/bookmarks":
        // return DialogRoute(context: , builder: builder)
        return pageRouteBuilderWrapper(settings, const BookmarksMobile());
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
}
