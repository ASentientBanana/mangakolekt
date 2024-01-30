import 'package:get_it/get_it.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/services/ffiService.dart';
import 'package:mangakolekt/services/navigation_service.dart';

GetIt locator = GetIt.instance;

setupServices() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerSingleton<BaseFFIService>(FFIService.loadService());
}
