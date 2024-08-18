library ffi_service;

import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/services/toast.dart';
import 'package:mangakolekt_archive_lib/mangakolekt_archive_zip/mangakolekt_archive_cover.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:ffi/ffi.dart';
import 'package:mangakolekt/generated/archive_ffi.dart' as nb;
import 'package:fluttertoast/fluttertoast.dart';
part './zip.dart';
part './utility.dart';
part './rar.dart';
