import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';


const String _libName = 'libzip';

/// The dynamic library in which the symbols for [MangakolektArchiveLibBindings] can be found.
DynamicLibrary getDyLib() {
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}

/// The bindings to the native functions in [_dylib].
// final nb.NativeLibrary _bindings = nb.NativeLibrary(_dylib);

int mangakolektUnzipArchiveLib(String bookPath, String output) {
  final Pointer<Utf8> fileStringPtr = bookPath.toNativeUtf8();
  final Pointer<Utf8> outPtr = output.toNativeUtf8();

  calloc.free(fileStringPtr);
  calloc.free(outPtr);
  return 1;
}
