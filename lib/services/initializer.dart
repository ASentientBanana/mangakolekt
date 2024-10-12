import 'package:mangakolekt/models/settings.dart';
import 'package:mangakolekt/services/database/databaseCore.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initAppStructure() async {
  await createAppFolder();
  await createGlobalCoversDir();
  await createCurrentDir();
  await createLogFile();
  await DatabaseCore.initDatabase();
  await Settings.init();
  // MangaToast("Initialization complete",color:Colors.green);
}

Future<bool> initPermissions() async {
  if (!isMobile()) {
    return true;
  }
  final success = await Permission.manageExternalStorage.request();

  return success.isGranted;
}
