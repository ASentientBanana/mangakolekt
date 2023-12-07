// Import the test package and Counter class

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/util.dart';

final mockData = [
  'One Piece - Digital Colored Comics_00.png',
  'One Piece - Digital Colored Comics_27.png',
  'One Piece - Digital Colored Comics_01.png',
  'One Piece - Digital Colored Comics_28.png',
  '_One Piece - Digital Colored Comics_02.png',
  'One Piece - Digital Colored Comics_29.png',
  'One Piece - Digital Colored Comics_02.png',
  'One Piece - Digital Colored Comics_30.png',
  'One Piece - Digital Colored Comics_03.png',
  'One Piece - Digital Colored Comics_31.png',
  'One Piece - Digital Colored Comics_04.png',
  'One Piece - Digital Colored Comics_32.png',
  'One Piece - Digital Colored Comics_05.png',
  'One Piece - Digital Colored Comics_33.png',
  'One Piece - Digital Colored Comics_06.png',
  'One Piece - Digital Colored Comics_34.png',
  'One Piece - Digital Colored Comics_07.png',
  'One Piece - Digital Colored Comics_35.png',
  '_One Piece - Digital Colored Comics_08.png',
  'One Piece - Digital Colored Comics_36.png',
  'One Piece - Digital Colored Comics_08.png',
  'One Piece - Digital Colored Comics_37.png',
  'One Piece - Digital Colored Comics_09.png',
  'One Piece - Digital Colored Comics_38.png',
  'One Piece - Digital Colored Comics_10.png',
  'One Piece - Digital Colored Comics_39.png',
  'One Piece - Digital Colored Comics_11.png',
  'One Piece - Digital Colored Comics_40.png',
  'One Piece - Digital Colored Comics_12.png',
  'One Piece - Digital Colored Comics_41.png',
  'One Piece - Digital Colored Comics_13.png',
  'One Piece - Digital Colored Comics_42.png',
  'One Piece - Digital Colored Comics_14.png',
  'One Piece - Digital Colored Comics_43.png',
  'One Piece - Digital Colored Comics_15.png',
  'One Piece - Digital Colored Comics_44.png',
  'One Piece - Digital Colored Comics_16.png',
  'One Piece - Digital Colored Comics_45.png',
  'One Piece - Digital Colored Comics_17.png',
  'One Piece - Digital Colored Comics_46.png',
  'One Piece - Digital Colored Comics_18.png',
  'One Piece - Digital Colored Comics_47.png',
  'One Piece - Digital Colored Comics_19.png',
  'One Piece - Digital Colored Comics_48.png',
  'One Piece - Digital Colored Comics_20.png',
  '_One Piece - Digital Colored Comics_49.png',
  'One Piece - Digital Colored Comics_21.png',
  'One Piece - Digital Colored Comics_50.png',
  'One Piece - Digital Colored Comics_22.png',
  'One Piece - Digital Colored Comics_51.png',
  'One Piece - Digital Colored Comics_23.png',
  'One Piece - Digital Colored Comics_99.jpg',
  'One Piece - Digital Colored Comics_24.png',
  'One Piece - Digital Colored Comics_99..jpg',
  'One Piece - Digital Colored Comics_25.png',
  'One Piece - Digital Colored Comics_99.png',
  'One Piece - Digital Colored Comics_26.png',
  ' ZZZ.png',
];

final targets = [
  "/home/petar/bigboy/Manga/OnePiece/Vol. 93.cbz",
  "/home/petar/bigboy/Manga/OnePiece/Vol. 94.cbz",
  "/home/petar/bigboy/Manga/OnePiece/Vol. 95.cbz",
  "/home/petar/Documents/Manga/One piece/Vol. 95.cbz"
];

const unzip_dest = '/home/petar/Documents/mangakolekt/current';
// void _unzip() {
//   test("Pages loaded", () async {
//     final book = await ArchiveController.loadBook(unzip_dest, targets[3]);
//     print(book?.name);
//     print(book?.pages.length);
//     expect(book!.pages.length, isNot(0));
//   });
// }

void fileSort() async {
  test("Testing file sorting", () async {
    final params = [targets[3].split('.').last, targets[3], unzip_dest];
    final book = await ArchiveController.unpack(params);
    final firstItter = book?.pages?.getRange(0, 10).map((e) => e.name).toList();

    if (firstItter != null) {
      print("RES: ");
      print(firstItter);
      final res = sortNumeric(firstItter);
      print(res);
    }

    // expect(actual, matcher)
  });
}

void main() {
  fileSort();
}
