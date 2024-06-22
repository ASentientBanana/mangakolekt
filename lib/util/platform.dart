import 'dart:io';

bool isSupportedPlatform() {
  return false;
}

bool isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}
