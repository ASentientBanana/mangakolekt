import 'dart:io';

import 'package:mangakolekt/models/global.dart';
import 'package:mangakolekt/services/settings.dart';
import 'package:mangakolekt/util/database/database_core.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initAppStructure() async {
  await createAppFolder();
  await createGlobalCoversDir();
  await createCurrentDir();
  await createLogFile();
  await DatabaseCore.initDatabase();
  await SettingsService.initialize();
}

Future<bool> initPermissions() async {
  if (!isMobile()) {
    return true;
  }
  final success = await Permission.manageExternalStorage.request();

  return success.isGranted;
}
