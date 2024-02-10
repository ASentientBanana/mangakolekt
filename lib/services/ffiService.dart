import 'dart:ffi'; // For FFI
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:mangakolekt/models/ffi.dart';

import 'package:path/path.dart';

typedef UnziperFunc = Pointer<Uint8> Function(
    Pointer<Uint8> filesString, Pointer<Uint8> path, Pointer<Uint8> output);
typedef ExtractImagesFromZipFunction = Pointer<Utf8> Function(
    Pointer<Utf8> zipFilePath, Pointer<Utf8> targetPath);

typedef ExtractImagesFromZipFunctionDart = Pointer<Utf8> Function(
    Pointer<Utf8> zipFilePath, Pointer<Utf8> targetPath);

class FFIService {
  // FFIService({required this.dyLib});

  static Future<List<String>> ffiUnzipSingleBook(
      String _bookPath, String _targetPath) async {
    final dyLib = loadService();
    final unzipBook = dyLib.lookupFunction<ExtractImagesFromZipFunction,
        ExtractImagesFromZipFunctionDart>("Unzip_Single_book");
    final bookPath = _bookPath.toNativeUtf8();
    final targetPath = _targetPath.toNativeUtf8();
    try {
      final filesString = unzipBook(bookPath, targetPath);
      List<String> dartStrings = filesString.toDartString().split("?&?");
      // calloc.free(filesString);
      calloc.free(bookPath);
      calloc.free(targetPath);
      return dartStrings;
    } catch (e) {
      calloc.free(bookPath);
      calloc.free(targetPath);
      return [];
    }
    
  }

  static Future<List<String>> ffiUnzipCovers(
      List<String> files, String path, String out) async {
    final dyLib = loadService();

    final unzipCoversFromDir =
        dyLib.lookupFunction<UnziperFunc, UnziperFunc>("Unzip_Covers");

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

  static DynamicLibrary loadWindows() {
    if (kReleaseMode) {
      // I'm on release mode, absolute linking
      String pathToLib =
          join(Directory(Platform.resolvedExecutable).parent.path,"manga_archive.dll");
      // return FFIService(dyLib: DynamicLibrary.open(pathToLib));
      return DynamicLibrary.open(pathToLib);
    } else {
      // I'm on debug mode, local linking
      var path = Directory.current.path;
      return DynamicLibrary.open(join(path,'lib','dev_lib','manga_archive.dll'));
    }
  }

  static DynamicLibrary loadLinux() {
    final String path;
    if (kReleaseMode) {
      // /home/petar/Projects/mangakolekt/dist/mangakolekt/dist/linux/mangakolekt:
      path = join(Directory(Platform.resolvedExecutable).parent.path,
          'lib/manga_archive.so');
    } else {
      path = 'lib/linux/manga_archive.so';
    }
    return DynamicLibrary.open(path);
  }

  //TODO: Add default implementation
  static loadUnsupported() {
    // Temp solution for the compiler
    return loadLinux();
  }

//
//  loadService returns a platform specific native ffiService
//  or a generic PlatformService
//  for the widest implementation as a generic return
//
  static DynamicLibrary loadService() {
    if (Platform.isLinux) {
      return loadLinux();
    }
    if (Platform.isWindows) {
      return loadWindows();
    }

    return loadUnsupported();
    // return UnsupportedNativePlatformService();
  }
}
