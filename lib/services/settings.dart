import 'package:mangakolekt/models/settings.dart';

class SettingsService {
  Settings settings = Settings();

  Future<void> save() async {}
  Future<Settings> load() async {
    return settings;
  }
}
