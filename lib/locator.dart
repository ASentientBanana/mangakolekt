import 'package:get_it/get_it.dart';
import 'package:mangakolekt/models/settings.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/store/reader.dart';

GetIt locator = GetIt.instance;

setupServices() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<Settings>(() => Settings.defaultConfig());
  locator.registerLazySingleton<LibraryStore>(() => LibraryStore());
  locator.registerLazySingleton<ReaderStore>(() => ReaderStore());
}
