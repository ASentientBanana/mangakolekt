import 'dart:ffi';
import 'dart:io';

bool isSupportedPlatform() {
  return Platform.isAndroid || Platform.isWindows || Platform.isLinux;
}

bool isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}

bool isAbleToLoadDynamicLib() {
  try {
    DynamicLibrary.open("manga_archive.so");
    return true;
  } catch (e) {
    return false;
  }
}
