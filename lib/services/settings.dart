import 'package:mangakolekt/models/settings.dart';

class SettingsService {
  Settings settings;

  SettingsService({required this.settings});

  Future<void> save() async {}
  Future<Settings> load() async {
    return settings;
  }

  static Future<void> initialize() async {}
}
