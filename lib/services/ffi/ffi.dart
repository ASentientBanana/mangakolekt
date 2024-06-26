library ffi_service;

import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:ffi/ffi.dart';
import 'package:mangakolekt/types/ffi.dart';
import 'package:mangakolekt/generated/archive_ffi.dart' as nb;

part './zip.dart';
part './utility.dart';
part './rar.dart';
