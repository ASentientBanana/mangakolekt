import 'package:flutter/material.dart';

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

  void errorDialog({required String error}) {
    if (navigatorKey.currentContext == null) {
      return;
    }
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          return AlertDialog(
            backgroundColor: colorScheme.background,
            title: const Text("A problem occurred"),
            content: Text(error),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              )
            ],
          );
        });
  }
}
