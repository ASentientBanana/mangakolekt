import 'dart:ffi'; // For FFI
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';

typedef UnziperFunc = Pointer<Uint8> Function(
    Pointer<Uint8> filesString, Pointer<Uint8> path, Pointer<Uint8> output);
// typedef FreeMem = ffi.Void Function(
//     ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Int32); // FFI fn signature

typedef ExtractImagesFromZipFunction = Void Function(
    Pointer<Utf8> zipFilePath, Pointer<Utf8> targetPath);

typedef ExtractImagesFromZipFunctionDart = void Function(
    Pointer<Utf8> zipFilePath, Pointer<Utf8> targetPath);

DynamicLibrary libForPlatform() {
  DynamicLibrary dylib;

  // For macOS
  if (Platform.isMacOS) {
    dylib = DynamicLibrary.open('macos/Runner/libunzip.dylib');
  }

  // For Windows
  else if (Platform.isWindows) {
    dylib = DynamicLibrary.open('windows/runner/libunzip.dll');
  }

  // For Linux
  else {
    dylib = DynamicLibrary.open('lib/linux/libunzip.so');
  }
  return dylib;
}

final dylib = libForPlatform();

final unziper = dylib.lookupFunction<UnziperFunc, UnziperFunc>("Unzip");
final unzipBook = dylib.lookupFunction<ExtractImagesFromZipFunction,
    ExtractImagesFromZipFunctionDart>("Unzip_Single_book");

Future<List<Uint8List>?> ffiUnzipSingleBook(
    String _bookPath, String _targetPath) async {
  print(_targetPath);
  final bookPath = _bookPath.toNativeUtf8();
  final targetPath = _targetPath.toNativeUtf8();
  unzipBook(bookPath, targetPath);

  calloc.free(bookPath);
  calloc.free(targetPath);
}

Future<List<String>> ffiUnzip(
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
  print("start");
  print(output.split("&?&")[0]);
  print("end");
  return output.split("&?&").toList();
}
