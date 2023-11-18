import 'dart:ffi'; // For FFI
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

import 'package:path/path.dart';

typedef UnziperFunc = Pointer<Uint8> Function(
    Pointer<Uint8> filesString, Pointer<Uint8> path, Pointer<Uint8> output);
// typedef FreeMem = ffi.Void Function(
//     ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Int32); // FFI fn signature

typedef ExtractImagesFromZipFunction = Int Function(
    Pointer<Utf8> zipFilePath, Pointer<Utf8> targetPath);

typedef ExtractImagesFromZipFunctionDart = int Function(
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

final unziper = dyLib.lookupFunction<UnziperFunc, UnziperFunc>("Unzip");
final unzipBook = dyLib.lookupFunction<ExtractImagesFromZipFunction,
    ExtractImagesFromZipFunctionDart>("Unzip_Single_book");

Future<bool> ffiUnzipSingleBook(String _bookPath, String _targetPath) async {
  final bookPath = _bookPath.toNativeUtf8();
  final targetPath = _targetPath.toNativeUtf8();
  try {
    int err = unzipBook(bookPath, targetPath);
    print("RETRUNDED: $err");
    if (err != 0) {
      return false;
    }
  } catch (e) {
    print("BAD FILE");
    print(e);
  }

  calloc.free(bookPath);
  calloc.free(targetPath);
  return true;
}

Future<List<String>> ffiUnzipCovers(
    List<String> files, String path, String out) async {
  final filesString = files.join("&&");

  final Pointer<Utf8> filesStringPtr = filesString.toNativeUtf8();
  final Pointer<Utf8> pathPtr = path.toNativeUtf8();
  final Pointer<Utf8> outPtr = out.toNativeUtf8();

  var res = unziper(filesStringPtr.cast<Uint8>(), pathPtr.cast<Uint8>(),
      outPtr.cast<Uint8>());
  calloc.free(filesStringPtr);
  calloc.free(pathPtr);
  calloc.free(outPtr);

  final output = res.cast<Utf8>().toDartString();
  return output.split("&?&").toList();
}
