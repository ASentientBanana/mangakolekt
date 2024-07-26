import 'dart:ffi';
import 'dart:io';

bool isSupportedPlatform() {
  return false;
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
