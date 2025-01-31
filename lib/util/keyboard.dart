import 'package:flutter/services.dart';

void keyDownEventHandler(KeyEvent event, {void Function()? nextPageCb}) {
  if (event is! KeyDownEvent) return;
  if (event.logicalKey.keyLabel == " " && nextPageCb != null) {
    nextPageCb();
  }
}
