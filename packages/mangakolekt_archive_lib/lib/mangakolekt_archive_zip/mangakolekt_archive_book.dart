import 'dart:typed_data';

import 'package:mangakolekt_archive_lib/mangakolekt_archive_lib.dart';
import 'package:mangakolekt_archive_lib/models/ffi_book_output_result.dart';
import 'package:mangakolekt_archive_lib/zip_bindings_generated.dart' as nb;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final dyLib = getDyLib();

final nb.NativeLibrary _bindings = nb.NativeLibrary(dyLib);

List<Page> mangakolektUnzipArchiveBook(String bookPath) {
  final Pointer<Utf8> fileStringPtr = bookPath.toNativeUtf8();

  final zeroPtr = calloc.allocate<Int>(1)..value = 0;

  final Pointer<nb.zip_t> archive =
      _bindings.zip_open(fileStringPtr.cast<Char>(), 0, zeroPtr);

  final number_of_entries = _bindings.zip_get_num_entries(archive, 0);

  final List<Page> pages = [];

  for (int i = 0; i < number_of_entries; i++) {
    Pointer<nb.zip_stat_t> statbuf = malloc();

    if (_bindings.zip_stat_index(archive, i, 0, statbuf) != 0) {
      continue;
    }

    final fileName = statbuf.ref.name.cast<Utf8>().toDartString();
    //size of the file, if its a dir its 0.
    int size = statbuf.ref.size;

    // as a test if its a file will be checking if zize > 0
    if (size <= 0) {
      calloc.free(statbuf);
      continue;
    }

    Pointer<nb.zip_file_t> f =
        _bindings.zip_fopen_index(archive, i, nb.ZIP_FL_UNCHANGED);

    Pointer<Char> content = malloc(size);

    if (_bindings.zip_fread(f, content.cast(), size) == 0) {
      calloc.free(content);
      calloc.free(statbuf);
      break;
    }

    final uint8Pointer = content.cast<Uint8>();
    final imageData = Uint8List.fromList(uint8Pointer.asTypedList(size));
    // final img = material.Image.memory(content.cast<Uint8>().asTypedList(size));
    pages.add(Page(image: imageData, name: fileName));
    calloc.free(content);
    calloc.free(statbuf);
  }
  calloc.free(zeroPtr);
  _bindings.zip_close(archive);
  return pages;
}
