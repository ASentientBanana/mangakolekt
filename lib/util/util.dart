import 'package:mangakolekt/models/book.dart';

List<BookCover> sortCoversNumeric(List<BookCover> list) {
  final regex = RegExp(r'\d+');

  List<int> extractNumbers(String s) =>
      regex.allMatches(s).map((m) => int.parse(m.group(0)!)).toList();

  return list
    ..sort((a, b) {
      final aNumbers = extractNumbers(a.name);
      final bNumbers = extractNumbers(b.name);
      final length = aNumbers.length;
      for (var i = 0; i < length; i++) {
        final comparison = aNumbers[i].compareTo(bNumbers[i]);
        if (comparison != 0) {
          return comparison;
        }
      }
      return a.name.compareTo(b.name);
    });
}

void swap(List list, int i, int j) {
  var temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}
