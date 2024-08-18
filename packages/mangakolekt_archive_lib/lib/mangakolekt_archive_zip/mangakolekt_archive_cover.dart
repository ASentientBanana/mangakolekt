import 'package:mangakolekt_archive_lib/mangakolekt_archive_lib.dart';
import 'package:mangakolekt_archive_lib/models/ffi_cover_output_result.dart';
import 'package:mangakolekt_archive_lib/zip_bindings_generated.dart' as nb;
import 'package:path/path.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

List<FFILibCoverOutputResult> mangakolektUnzipArchiveCover(
    List<String> files, String output) {
  //init native lib

  final dyLib = getDyLib();
  final nb.NativeLibrary _bindings = nb.NativeLibrary(dyLib);

  String type = '';
  final zeroPtr = calloc.allocate<Int>(1)..value = 0;
  String outputPath = '';
  String name = '';

  final List<FFILibCoverOutputResult> covers = [];
  for (var file in files) {
    final start = DateTime.now().millisecondsSinceEpoch;

    final Pointer<Utf8> fileStringPtr = file.toNativeUtf8();
    name = basenameWithoutExtension(file);

    //open archive
    final Pointer<nb.zip_t> archive =
        _bindings.zip_open(fileStringPtr.cast<Char>(), 0, zeroPtr);

    final numberOfEntries = _bindings.zip_get_num_entries(archive, 0);

    //Loop over files and find first file.
    for (int i = 0; i < numberOfEntries; i++) {
      Pointer<nb.zip_stat_t> statbuf = malloc();

      if (_bindings.zip_stat_index(archive, i, 0, statbuf) != 0) {
        continue;
      }

      final fileName = statbuf.ref.name.cast<Utf8>().toDartString();
      //size of the file, if its a dir its 0.
      int size = statbuf.ref.size;
      type = extension(fileName);

      // as a test if its a file will be checking if size > 0
      if (size <= 0) {
        calloc.free(statbuf);
        continue;
      }
      // open file in archive by index
      Pointer<nb.zip_file_t> f =
          _bindings.zip_fopen_index(archive, i, nb.ZIP_FL_UNCHANGED);

      Pointer<Char> content = malloc(size);

      if (_bindings.zip_fread(f, content.cast(), size) == 0) {
        calloc.free(content);
        calloc.free(statbuf);
        break;
      }

      // DateTime.now() is used as a unique name for the files inside copied to the covers dir.
      final randomName = "${DateTime.now().microsecondsSinceEpoch}$type";

      outputPath = join(output, randomName);

      Pointer<nb.FILE> outputFile = _bindings.fopen(
        outputPath.toNativeUtf8().cast<Char>(),
        "wb".toNativeUtf8().cast<Char>(),
      );

      _bindings.fwrite(
          Pointer.fromAddress(content.address), size, size, outputFile);

      _bindings.fclose(outputFile);
      calloc.free(content);
      calloc.free(statbuf);
      _bindings.zip_close(archive);

      covers.add(FFILibCoverOutputResult(
        archiveName: name,
        directoryFile: file,
        destinationPath: outputPath,
      ));
      final end = DateTime.now().millisecondsSinceEpoch;
      print("Time per cover:: ${(end - start) / 1000}");
      break;
    }
  }
  calloc.free(zeroPtr);

  return covers;
  // if (name.isEmpty) {
  //   return null;
  // }
  // return FFILibCoverOutputResult(
  //   archiveName: name,
  //   directoryFile: bookPath,
  //   destinationPath: outputPath,
  // );
}
