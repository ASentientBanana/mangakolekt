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
      if (aNumbers.length == 0 || bNumbers.length == 0) {
        return a.compareTo(b);
      }
      final comparison = aNumbers[0].compareTo(bNumbers[0]);
      if (comparison != 0) {
        return comparison;
      }
      // for (var i = 0; i < length; i++) {
      //   if (comparison != 0) {
      //   }
      // }
      return a.compareTo(b);
    });
}

List<BookCover> sortCoversNumeric(List<BookCover> list) {
  return list
    ..sort((a, b) {
      final aNumbers = extractNumbers(a.name);
      final bNumbers = extractNumbers(b.name);
      final length = aNumbers.length;
      for (var i = 0; i < length; i++) {
        // print("$aNumbers - $bNumbers");
        final comparison = aNumbers[i].compareTo(bNumbers[i]);
        if (comparison != 0) {
          return comparison;
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
