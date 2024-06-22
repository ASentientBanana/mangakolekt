part of ffi_service;

DynamicLibrary loadWindows() {
  if (kReleaseMode) {
// I'm on release mode, absolute linking
    String pathToLib = join(Directory(Platform.resolvedExecutable).parent.path,
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

DynamicLibrary loadLinux() {
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
loadUnsupported() {
// throw Error.safeToString("Platform unsuported");
// Temp solution for the compiler
  return loadLinux();
}

DynamicLibrary loadAndroid() {
  const path = 'manga_archive.so';
  return DynamicLibrary.open(path);
}

//
//  loadService returns a platform specific native ffiService
//  or a generic PlatformService
//  for the widest implementation as a generic return
//
DynamicLibrary? loadService() {
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

List<FFICoverOutputResult> extractCovers(Iterable rawCovers){
  final List<FFICoverOutputResult> covers = [];
  for(var element in rawCovers){
    if (element != null) {
      final cover = FFICoverOutputResult.fromMap(element);
      if (cover != null) {
        covers.add(cover);
      }
    }
  }
  return covers;
}
