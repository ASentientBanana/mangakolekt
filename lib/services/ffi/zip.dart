part of ffi_service;

List<FFICoverOutputResult> ffiUnzipCovers(
    List<String> files, String path, String out) {
  final dyLib = loadService();

  if (dyLib == null) {
    return [];
  }

  final nativeBindings = nb.NativeLibrary(dyLib);

  // convert to json
  final filesString = jsonEncode(files);

// send data to ffi
  final Pointer<Utf8> filesStringPtr = filesString.toNativeUtf8();
  final Pointer<Utf8> pathPtr = path.toNativeUtf8();
  final Pointer<Utf8> outPtr = out.toNativeUtf8();
  var res = nativeBindings.Unzip_Covers(
      filesStringPtr.cast<Char>(), pathPtr.cast<Char>(), outPtr.cast<Char>());

  calloc.free(filesStringPtr);
  calloc.free(pathPtr);
  calloc.free(outPtr);

// json -> List
  final output = res.cast<Utf8>().toDartString();
  final ffiOut = jsonDecode(output);

  if (ffiOut.isEmpty) {
    return [];
  }
  calloc.free(res);

  //map to obj
  if ((ffiOut is! List)) {
    return [];
  }
  return extractCovers((ffiOut as Iterable));
}

Future<void> ffiUnzipSingleBook(String _bookPath, String _targetPath) async {
  final dyLib = loadService();
  if (dyLib == null) {
    return;
  }
  final nativeBindings = nb.NativeLibrary(dyLib);
  final pBookPath = _bookPath.toNativeUtf8().cast<Char>();
  final pTargetPath = _targetPath.toNativeUtf8().cast<Char>();

  try {
    nativeBindings.Unzip_Single_book(pBookPath, pTargetPath);
    // return filesList;
  } catch (e) {
    //TODO:
  } finally {
    calloc.free(pBookPath);
    calloc.free(pTargetPath);
  }
}
