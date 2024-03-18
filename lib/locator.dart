import 'package:get_it/get_it.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/models/settings.dart';
import 'package:mangakolekt/services/ffiService.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/services/settings.dart';

GetIt locator = GetIt.instance;

setupServices() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  // locator.registerSingleton<FFIService>(FFIService.loadService());
  locator.registerLazySingleton<SettingsService>(
      () => SettingsService(settings: Settings.defaultConfig()));
}
