part of ffi_service;

Future<List<String>> ffiUnrarSingleBook(
    String _bookPath, String _targetPath) async {
  final dyLib = loadService();
  if (dyLib == null) {
    return [];
  }
  final nativeBindings = nb.NativeLibrary(dyLib);
  final pBookPath = _bookPath.toNativeUtf8().cast<Char>();
  final pTargetPath = _targetPath.toNativeUtf8().cast<Char>();

  try {
    nativeBindings.Unrar_Single_book(pBookPath, pTargetPath);

// calloc.free(pFiles);
    calloc.free(pBookPath);
    calloc.free(pTargetPath);
    return [];
// return filesList;
  } catch (e) {
    calloc.free(pBookPath);
    calloc.free(pTargetPath);
    return [];
  }
}

List<FFICoverOutputResult> ffiUnrarCovers(
    List<String> files, String path, String out) {
  final dyLib = loadService();

  if (dyLib == null) {
    return [];
  }

  final nativeBindings = nb.NativeLibrary(dyLib);

// TODO:
// convert to json
  final filesString = jsonEncode(files);

// final filesString = files.join("&&");

// send data to ffi
  final Pointer<Utf8> filesStringPtr = filesString.toNativeUtf8();
  final Pointer<Utf8> pathPtr = path.toNativeUtf8();
  final Pointer<Utf8> outPtr = out.toNativeUtf8();
  var res = nativeBindings.Unrar_Covers(
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
//Expected structure
// {
// archiveName:string
// destinationPath:string
//  directoryFile:string
// }
//map to obj

  if ((ffiOut is! List)) {
    print('FFI NOT List: ${ffiOut.runtimeType}');
    return [];
  }
  final List<FFICoverOutputResult> covers = [];
  (ffiOut as Iterable).forEach((element) {
    if (element != null) {
      final _cover = FFICoverOutputResult.fromMap(element);
      if (_cover != null) {
        covers.add(_cover);
      }
    }
  });
  print("ffi output:: $covers");
  return covers;
}
