
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mangakolekt/util/platform.dart';


void MangaToast(String message, {Color color = Colors.green}){

  if(!isMobile()){
    return;
  }

  Fluttertoast.showToast(msg: message,backgroundColor: color,gravity: ToastGravity.BOTTOM_RIGHT);
}
