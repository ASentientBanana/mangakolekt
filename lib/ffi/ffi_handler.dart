import 'dart:ffi'; // For FFI
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:mangakolekt/util/util.dart';
import 'dart:typed_data';

import 'package:path/path.dart';

typedef UnziperFunc = Pointer<Uint8> Function(
    Pointer<Uint8> filesString, Pointer<Uint8> path, Pointer<Uint8> output);
typedef ExtractImagesFromZipFunction = Pointer<Utf8> Function(
    Pointer<Utf8> zipFilePath, Pointer<Utf8> targetPath);

typedef ExtractImagesFromZipFunctionDart = Pointer<Utf8> Function(
    Pointer<Utf8> zipFilePath, Pointer<Utf8> targetPath);

DynamicLibrary libForPlatform() {
  DynamicLibrary dyLib;

  // For macOS
  if (Platform.isMacOS) {
    dyLib = DynamicLibrary.open('macos/Runner/libunzip.dylib');
  }

  // For Windows
  else if (Platform.isWindows) {
    if (kReleaseMode) {
      // I'm on release mode, absolute linking
      final String local_lib =
          join('data', 'flutter_assets', 'assets', 'libunzip.dll');
      String pathToLib =
          join(Directory(Platform.resolvedExecutable).parent.path, local_lib);
      dyLib = DynamicLibrary.open(pathToLib);
    } else {
      // I'm on debug mode, local linking
      var path = Directory.current.path;
      dyLib = DynamicLibrary.open(join(path, 'assets', 'libunzip.dll'));
    }
  }

  // For Linux
  else {
    dyLib = DynamicLibrary.open('lib/linux/libunzip.so');
  }
  return dyLib;
}

final dyLib = libForPlatform();

final unzipCoversFromDir =
    dyLib.lookupFunction<UnziperFunc, UnziperFunc>("Unzip_Covers");
final unzipBook = dyLib.lookupFunction<ExtractImagesFromZipFunction,
    ExtractImagesFromZipFunctionDart>("Unzip_Single_book");

//  final FreeStringsFunc freeStrings = dyLib
//       .lookupFunction<FreeStringsFunc>('FreeStrings');

Future<List<String>> ffiUnzipSingleBook(
    String _bookPath, String _targetPath) async {
  final bookPath = _bookPath.toNativeUtf8();
  final targetPath = _targetPath.toNativeUtf8();
  try {
    final filesString = unzipBook(bookPath, targetPath);

    //read pointer til the end

    List<String> dartStrings = filesString.toDartString().split("?&?");
    calloc.free(filesString);

    return dartStrings;
  } catch (e) {
    print(e);
  }

  calloc.free(bookPath);
  calloc.free(targetPath);
  return [];
}

Future<List<String>> ffiUnzipCovers(
    List<String> files, String path, String out) async {
  final filesString = files.join("&&");

  final Pointer<Utf8> filesStringPtr = filesString.toNativeUtf8();
  final Pointer<Utf8> pathPtr = path.toNativeUtf8();
  final Pointer<Utf8> outPtr = out.toNativeUtf8();
  var res = unzipCoversFromDir(filesStringPtr.cast<Uint8>(),
      pathPtr.cast<Uint8>(), outPtr.cast<Uint8>());

  calloc.free(filesStringPtr);
  calloc.free(pathPtr);
  calloc.free(outPtr);

  final output = res.cast<Utf8>().toDartString();
  // calloc.free(res);
  return output.split("&?&").toList();
}
