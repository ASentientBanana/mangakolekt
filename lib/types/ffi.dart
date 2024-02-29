import 'dart:ffi'; // For FFI
import 'package:ffi/ffi.dart';

typedef UnziperFunc = Pointer<Uint8> Function(
    Pointer<Uint8> filesString, Pointer<Uint8> path, Pointer<Uint8> output);

typedef ExtractImagesFromZipFunction = Pointer<Utf8> Function(
    Pointer<Utf8> zipFilePath, Pointer<Utf8> targetPath);

typedef ExtractImagesFromZipFunctionDart = Pointer<Utf8> Function(
    Pointer<Utf8> zipFilePath, Pointer<Utf8> targetPath);

typedef CheckForLibDirFunction = Void Function(Pointer utf8);
typedef CheckForLibDirFunctionDart = void Function(Pointer utf8);
