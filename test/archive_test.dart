// Import the test package and Counter class

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

void main() {
  group('Sorting', () {
    test('Sorting numeric', () {
      final res = sortNumeric(mockData);
      expect(res.length, mockData.length);
    });

    test('Sorting numeric pages', () {
      final pages =
          mockData.map((e) => PageEntry(name: e, image: Image.network('src')));
      final res2 = sortCoversPagesNumeric(pages.toList());

      expect(res2.length, pages.length);
    });
  });
}
