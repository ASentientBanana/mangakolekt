import 'dart:ffi'; // For FFI
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/types/ffi.dart';
import 'package:mangakolekt/generated/archive_ffi.dart' as nb;

import 'package:path/path.dart';

class FFIService {
  // FFIService({required this.dyLib});

  static Future<List<String>> ffiGetDirContents(String dirPath) async {
    List<String> files = [];
    final dyLib = loadService();
    if (dyLib == null) {
      return [];
    }
    final nativeBindings = nb.NativeLibrary(dyLib);
    final pDirPath = dirPath.toNativeUtf8().cast<Char>();
    final filesString = nativeBindings.Get_Files_From_Dir(pDirPath);
    files = filesString.cast<Utf8>().toDartString().split("&&");
    print("Found in dart: ");
    print(files);

    calloc.free(filesString);
    calloc.free(pDirPath);
    return files;
  }

  static Future<void> checkLibDir(String path) async {
    //Append lib folder name to the path
    final fullPath = join(path, libFolderName);
    final dyLib = loadService();
    if (dyLib == null) {
      return;
    }
    final nativeBindings = nb.NativeLibrary(dyLib);

    final fullPathPtr = fullPath.toNativeUtf8().cast<Char>();
    nativeBindings.Check_For_Lib_dir(fullPathPtr);
    calloc.free(fullPathPtr);
  }

  static Future<List<String>> ffiUnzipSingleBook(
      String _bookPath, String _targetPath) async {
    final dyLib = loadService();
    if (dyLib == null) {
      return [];
    }
    final nativeBindings = nb.NativeLibrary(dyLib);
    final pBookPath = _bookPath.toNativeUtf8().cast<Char>();
    final pTargetPath = _targetPath.toNativeUtf8().cast<Char>();

    try {
      final pFiles =
          await nativeBindings.Unzip_Single_book(pBookPath, pTargetPath);
      final files = pFiles.cast<Utf8>().toDartString().split("?&?");

      calloc.free(pFiles);
      calloc.free(pBookPath);
      calloc.free(pTargetPath);
      return files;
    } catch (e) {
      calloc.free(pBookPath);
      calloc.free(pTargetPath);
      return [];
    }
    // final unzipBook = dyLib.lookupFunction<ExtractImagesFromZipFunction,
    //     ExtractImagesFromZipFunctionDart>("Unzip_Single_book", isLeaf: true);
    // final bookPath = _bookPath.toNativeUtf8();
    // final targetPath = _targetPath.toNativeUtf8();
    // try {
    //   final filesString = unzipBook(bookPath, targetPath);
    //   List<String> dartStrings = filesString.toDartString().split("?&?");
    //   // calloc.free(filesString);
    //   calloc.free(bookPath);
    //   calloc.free(targetPath);
    //   return dartStrings;
    // } catch (e) {
    //   calloc.free(bookPath);
    //   calloc.free(targetPath);
    //   return [];
    // }
  }

  static Future<List<String>> ffiUnzipCovers(
      List<String> files, String path, String out) async {
    final dyLib = loadService();

    if (dyLib == null) {
      return [];
    }

    final unzipCoversFromDir = dyLib
        .lookupFunction<UnziperFunc, UnziperFunc>("Unzip_Covers", isLeaf: true);

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
      String pathToLib = join(
          Directory(Platform.resolvedExecutable).parent.path,
          "manga_archive.dll");
      // return FFIService(dyLib: DynamicLibrary.open(pathToLib));
      return DynamicLibrary.open(pathToLib);
    } else {
      // I'm on debug mode, local linking
      var path = Directory.current.path;
      return DynamicLibrary.open(
          join(path, 'lib', 'dev_lib', 'manga_archive.dll'));
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
    print("Platform unsuported");
    // throw Error.safeToString("Platform unsuported");
    // Temp solution for the compiler
    return loadLinux();
  }

  static DynamicLibrary loadAndroid() {
    const path = 'manga_archive.so';
    return DynamicLibrary.open(path);
  }

//
//  loadService returns a platform specific native ffiService
//  or a generic PlatformService
//  for the widest implementation as a generic return
//
  static DynamicLibrary? loadService() {
    if (Platform.isLinux) {
      return loadLinux();
    }
    if (Platform.isWindows) {
      return loadWindows();
    }
    if (Platform.isAndroid) {
      return loadAndroid();
    }

    return null;
    // return UnsupportedNativePlatformService();
  }
}
