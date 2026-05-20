import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/reader/singleImage.dart';
import 'package:path/path.dart' as p;
import 'package:collection/collection.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Alignment getAliment(bool isDouble, int index) {
  if (!isDouble) {
    return Alignment.center;
  }
  // This is to keep the images together when in double page view
  return index == 0 ? Alignment.centerRight : Alignment.centerLeft;
}

Future<Book?> getBook(BuildContext context, String bookPath, int? id,
    ArchiveController archiveService) async {
  if (!context.mounted) {
    return null;
  }
  final dest = await getCurrentDirPath();
  Book? book;
  imageCache.clear();

  try {
    book = await archiveService.unpack(bookPath,
        type: extractType(bookPath), dest: dest);
    if (id != null && book?.id == null) {
      book?.id = id;
    }
  } catch (e) {
    if (!context.mounted) {
      return null;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  return book;
}

Future<Map<String, String>> checkForNextBook(String path) async {
  //get dir path
  final containingDirPath = p.dirname(path);

  // scan dir for files

  final dir = Directory(containingDirPath);

  final Map<String, String> map = {};

  // check if dir exists
  if (!(await dir.exists())) {
    return map;
  }
  // Get contents
  final contentsList = await dir.list().toList();
  final List<String> files = [];

  //Grab only the files
  for (var i = 0; i < contentsList.length; i++) {
    if ((await contentsList[i].stat()).type == FileSystemEntityType.file) {
      files.add(contentsList[i].path);
    }
  }
  //sort files numerically
  files.sort(compareNatural);

  //Find index of the file
  final fileIndex = files.indexOf(path);
  //Get next file path from list
  if (fileIndex + 1 < files.length) {
    map['next'] = files[fileIndex + 1];
  }
  // print("Previous book: ${files[fileIndex - 1]}");
  if (fileIndex - 1 >= 0) {
    map['prev'] = files[fileIndex - 1];
  }

  return map;
}

// List<Widget> renderPages(ReaderController readerController, Size size,
// )  {
//   // A more verbose page rendering way.
//   final List<int> pageIndexes;
//
//   final List<Widget> pages = [];
//   // final List<Map<String, double>> aspects = [];
//
//   //check if double page view is toggled
//   if (readerController.isRightToLeftMode) {
//     pageIndexes = readerController.getCurrentPages();
//   } else {
//     pageIndexes = readerController.getCurrentPages().reversed.toList();
//   }
//
//   final isDouble = pageIndexes.length == 2;
//
//   final img = readerController.pages[pageIndexes[0]].entry.image;
//   final w = img.width ?? 1;
//   final h = img.height ?? 1;
//   final isWide = w > h;
//   final aspect = isWide ? w / h : h / w;
//
//   double imgWidth;
//   if (isWide) {
//     imgWidth = size.width;
//   } else {
//     imgWidth = size.width / 2;
//   }
//   final imgHeight = imgWidth * aspect;
//
//   for (var i = 0; i < pageIndexes.length; i++) {
//     final pageIndex = pageIndexes[i];
//     pages.add(
//       SingleImage(
//         isDouble: isDouble,
//         // increment: onClick ?? onTap,
//         image: readerController.pages[pageIndex].entry.image,
//         imageIndex: i,
//         size: Size(imgWidth, imgHeight),
//         // size: Size(imgHeight, imgWidth),
//       ),
//     );
//   }
//   return pages;
// }

List<Widget> renderPages(ReaderController rc, Size size) {
  // A more verbose page rendering way.
  final List<Widget> pages = [];
  final List<int> pageIndexes;
  if (rc.isRightToLeftMode) {
    pageIndexes = rc.getCurrentPages();
  } else {
    pageIndexes = rc.getCurrentPages().reversed.toList();
  }

  final img = rc.pages[pageIndexes[0]].entry.image;
  final w = img.width ?? 1;
  final h = img.height ?? 1;
  final isWide = w > h;

  // Calculate new aspect ratio
  final aspect = isWide ? w / h : h / w;

  double imgWidth;

  if (isWide) {
    imgWidth = size.width;
  } else {
    if (rc.isDoublePageView) {
      imgWidth = size.width / 2;
    } else {
      imgWidth = size.width;
    }
  }

  final imgHeight = imgWidth * aspect;

  for (var i = 0; i < pageIndexes.length; i++) {
    final pageIndex = pageIndexes[i];
    pages.add(
      Image(
        width: imgWidth,
        height: imgHeight,
        // alignment: Alignment.centerRight,
        alignment: getAliment(pageIndexes.length == 2, i),
        image: rc.pages[pageIndex].entry.image.image,
      ),
    );
  }
  return pages;
}

List<Widget> wrapPagesDesktop(
    List<Widget> pages, void Function(PointerDownEvent) onClick) {
  return pages
      .map(
        (element) => Listener(
          onPointerDown: onClick,
          child: element,
        ),
      )
      .toList();
}
