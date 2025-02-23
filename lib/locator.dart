import 'package:get_it/get_it.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/controllers/archiveControllers.dart';
import 'package:mangakolekt/models/settings.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/store/reader.dart';

GetIt locator = GetIt.instance;

setupServices() {
  locator.registerLazySingleton<LibraryStore>(() => LibraryStore());
  locator.registerLazySingleton<ReaderStore>(() => ReaderStore());
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<Settings>(Settings.defaultConfig());
  locator.registerSingleton<ArchiveController>(
      ArchiveController(archiveControllers));
}
