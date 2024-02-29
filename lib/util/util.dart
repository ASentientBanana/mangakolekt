import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';

final regex = RegExp(r'\d+');
List<int> extractNumbers(String s) =>
    regex.allMatches(s).map((m) => int.parse(m.group(0)!)).toList();

List<String> sortNumeric(List<String> list) {
  return list
    ..sort((a, b) {
      final aNumbers = extractNumbers(a);
      final bNumbers = extractNumbers(b);
      if (aNumbers.isEmpty || bNumbers.isEmpty) {
        return a.compareTo(b);
      }
      final comparison = aNumbers[0].compareTo(bNumbers[0]);
      if (comparison != 0) {
        return comparison;
      }

      return a.compareTo(b);
    });
}

int parseIntPrefix(String s) {
  var re = RegExp(r'(-?[0-9]+).*');
  var match = re.firstMatch(s);
  if (match == null) {
    return 1;
  }
  return int.parse(match.group(1)!);
}

int compareIntPrefixes(String a, String b) {
  var aValue = parseIntPrefix(a);
  var bValue = parseIntPrefix(b);
  if (aValue != null && bValue != null) {
    return aValue - bValue;
  }

  if (aValue == null && bValue == null) {
    // If neither string has an integer prefix, sort the strings lexically.
    return a.compareTo(b);
  }

  // Sort strings with integer prefixes before strings without.
  if (aValue == null) {
    return 1;
  } else {
    return -1;
  }
}

List<BookCover> sortCoversNumeric(List<BookCover> list) {
  return list
    ..sort((a, b) {
      final aNumbers = extractNumbers(a.name);
      final bNumbers = extractNumbers(b.name);
      final length = aNumbers.length;
      for (var i = 0; i < length; i++) {
        // print("$aNumbers - $bNumbers");
        try {
          final comparison = aNumbers[i].compareTo(bNumbers[i]);
          if (comparison != 0) {
            return comparison;
          }
        } catch (e) {
          return a.name.compareTo(b.name);
        }
      }
      return a.name.compareTo(b.name);
    });
}

List<PageEntry> sortCoversPagesNumeric(List<PageEntry> _list) {
  final list = [..._list];
  return list
    ..sort(
      (a, b) {
        final aNumbers = extractNumbers(a.name);
        final bNumbers = extractNumbers(b.name);
        if (aNumbers.isEmpty && bNumbers.isNotEmpty) {
          return 1;
        } else if (aNumbers.isNotEmpty && bNumbers.isEmpty) {
          return -1;
        } else if (aNumbers.isEmpty && bNumbers.isEmpty) {
          return 0;
        }
        final length = aNumbers.length;
        for (var i = 0; i < length; i++) {
          final comparison = aNumbers[i].compareTo(bNumbers[i]);
          if (comparison != 0) {
            return comparison;
          }
        }
        return a.name.compareTo(b.name);
      },
    );
}

void swap(List list, int i, int j) {
  var temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}

void switchReadingDirection(list) {
  final len = list.length;

  for (var i = 0; i < len; i++) {
    if (i + 1 < len && i % 2 == 0) {
      swap(list, i, i + 1);
    }
  }
}

List<int> colorToList(Color clr) {
  return [clr.alpha, clr.red, clr.green, clr.blue];
}

Route<Widget> pageRouteBuilderWrapper(RouteSettings settings, Widget page) {
  return PageRouteBuilder(
    settings:
        settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
  );
}

bool isMobile() {
  return (Platform.isAndroid || Platform.isIOS);
}

bool validateMap(Map map, List<String> keys) {
  for (var i = 0; i < keys.length; i++) {
    if (map[keys[i]] == null) {
      return false;
    }
  }

  return true;
}
