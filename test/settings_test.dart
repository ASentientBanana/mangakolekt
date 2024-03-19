import 'package:flutter_test/flutter_test.dart';
import 'package:mangakolekt/models/settings.dart';

void main() {
  test('testing load/save settings', () async {
    const path = '/home/petar/Documents/mangakolekt';

    // final loadedSettings = await Settings.load(path);
    final s = Settings();
    // s.data = loadedSettings;
    s.data.add(Setting(
        type: "int",
        name: "t2est",
        description: "12ccccccccccc2c",
        value: 123));
    final expectedLen = s.data.length;
    await Settings.save(s, path);
    // final loadedSettings2 = await Settings.load(path);
    // expect(loadedSettings2.length, expectedLen);
  });

  test('init', () async {
    const path = '/home/petar/Documents/mangakolekt';
    final _default = Settings.defaultConfig();
    expect(_default.data.length, 2);
  });
}
