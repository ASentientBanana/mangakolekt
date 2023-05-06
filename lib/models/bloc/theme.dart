import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mangakolekt/util/util.dart';

class ThemeStore {
  late Color primaryColor;
  late Color accentColor;
  late Color backgroundColor;
  late Color appbarBackground;
  late Color tertiary;
  late Color textColor;

  ThemeStore(
      {required this.appbarBackground,
      required this.tertiary,
      required this.accentColor,
      required this.primaryColor,
      required this.backgroundColor,
      required this.textColor});

  static listToColor(List<int> clr) {
    if (clr.length == 4) {
      return Color.fromARGB(clr[0], clr[1], clr[2], clr[3]);
    } else if (clr.length == 3) {
      return Color.fromARGB(1, clr[0], clr[1], clr[2]);
    } else {
      return Colors.black;
    }
  }

  Map<String, dynamic> toJSON() => {
        "appbarBackground": colorToList(appbarBackground),
        "tertiary": colorToList(tertiary),
        "accentColor": colorToList(accentColor),
        "primaryColor": colorToList(primaryColor),
        "backgroundColor": colorToList(backgroundColor),
        "textColor": colorToList(textColor),
      };

  ThemeStore.fromJSON(Map<String, dynamic> json) {
    //Remove the ! and add a check!!
    primaryColor = ThemeStore.listToColor(json["primaryColor"]!.cast<int>());
    accentColor = ThemeStore.listToColor(json["accentColor"]!.cast<int>());
    backgroundColor =
        ThemeStore.listToColor(json["backgroundColor"]!.cast<int>());
    appbarBackground =
        ThemeStore.listToColor(json["appbarBackground"]!.cast<int>());
    tertiary = ThemeStore.listToColor(json["tertiary"]!.cast<int>());
    textColor = ThemeStore.listToColor(json["textColor"]!.cast<int>());
  }

  ThemeStore.defaultTheme() {
    primaryColor = const Color.fromARGB(234, 197, 125, 1);
    accentColor = const Color.fromARGB(237, 17, 20, 34);
    backgroundColor = const Color.fromARGB(181, 28, 42, 59);
    appbarBackground = const Color.fromARGB(206, 36, 48, 58);
    tertiary = const Color.fromARGB(234, 36, 48, 58);
    textColor = const Color.fromARGB(256, 0, 0, 0);
  }
}
