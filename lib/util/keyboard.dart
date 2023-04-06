import 'package:flutter/services.dart';

void keyDownEventHandler(RawKeyEvent event, {void Function()? nextPageCb}) {
  if (event is! RawKeyDownEvent) return;
  if (event.logicalKey.keyLabel == " " && nextPageCb != null) {
    nextPageCb();
  }
}
