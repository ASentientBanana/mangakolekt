import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/dialog.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, Object? arguments) async {
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushAndPop(String routeName, Object? arguments) async {
    return navigatorKey.currentState
        ?.popAndPushNamed(routeName, arguments: arguments);
  }

  void goBack({dynamic data}) {
    navigatorKey.currentState?.pop(data);
  }

  void openDialog({required String content, required type}) {
    if (navigatorKey.currentContext == null) {
      return;
    }

    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => MangaDialog(
        content: content,
      ),
    );
  }
}
