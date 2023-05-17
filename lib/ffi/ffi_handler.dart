// file name fficheck.dart
import 'dart:convert';
import 'dart:ffi'; // For FFI
import 'package:ffi/ffi.dart';

typedef UnziperFunc = Pointer<Uint8> Function(
    Pointer<Uint8> filesString, Pointer<Uint8> path, Pointer<Uint8> output);
// typedef FreeMem = ffi.Void Function(
//     ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Int32); // FFI fn signature

final dylib =
    DynamicLibrary.open("/home/petar/Projects/mangakolekt/lib/ffi/libunzip.so");

final unziper = dylib.lookupFunction<UnziperFunc, UnziperFunc>("Unzip");
// final ffi.Void freestring =
//     dylib.lookup<ffi.NativeFunction<FreeMem>>('FreeStrings').asFunction();

Future<List<String>> ffiUnzip(
    List<String> files, String path, String out) async {
  final filesString = files.join("&&");
  final utf8Bytes = utf8.encode(filesString);
  final len = files.length;

  // final filesStringPtr = calloc<Uint8>(utf8Bytes.length + 1);
  // final pathPtr = calloc<Uint8>(utf8.encode(path).length + 1);
  // final outPtr = calloc<Uint8>(utf8.encode(out).length + 1);

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
