import 'dart:convert';
import 'dart:io';

import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path/path.dart';

class Setting {
  late String type;
  late String name;
  late String description;
  late dynamic value;
  Setting({
    required this.type,
    required this.name,
    required this.description,
    required this.value,
  });

  Setting.asNull() {
    type = '';
    name = '';
    description = '';
    value = null;
  }

  static Setting fromMap(dynamic map) {
    final isValid = validateMap(map, [
      'type',
      'name',
      'description',
      'value',
    ]);
    if (!isValid) {
      return Setting.asNull();
    }

    return Setting(
        type: map['type'],
        name: map['name'],
        description: map['description'],
        value: map['value']);
  }
}

class Settings {
  List<Setting> data = [];

  Settings();

  Settings.defaultConfig() {
    data = [
      Setting(
          type: 'bool',
          name: 'RTL',
          description: 'Default to Right to Left when reading',
          value: false),
      Setting(
          type: 'bool',
          name: 'doublePage',
          description: 'Default to double page view',
          value: false),
    ];
  }

  static Future<File?> loadSettingsFile(String path) async {
    final file = File(join(path, 'settings.json'));
    if (await file.exists()) {
      return null;
    }
    return file;
  }

  static Future<List<Setting>> load(String path) async {
    final file = File(join(path, 'settings.json'));
    print(file.path);
    if (!await file.exists()) {
      return [];
    }
    final map = await file.readAsString();
    final jsonData = jsonDecode(map) as List<dynamic>;
    final _data = jsonData
        .map((_map) => Setting.fromMap(_map))
        .where((element) => element.value != null)
        .toList();

    return _data;
  }

  static Future<void> save(Settings settings, String path) async {
    final file = File(join(path, 'settings.json'));
    if (!await file.exists()) {
      return;
    }
    final _map = settings.data
        .map((e) => {
              "type": e.type,
              "name": e.name,
              "description": e.description,
              "value": e.value
            })
        .toList();
    final jsonString = jsonEncode(_map);
    await file.writeAsString(jsonString);
  }

  static Future<Settings> init(String path) async {
    final file = File(join(path, 'settings.json'));

    if (!await file.exists()) {
      await file.create();
      final _default = Settings.defaultConfig();
      await save(_default, file.path);
      return _default;
    }

    final fSettings = await load(path);
    final _settings = Settings();
    _settings.data = fSettings;
    return _settings;
  }

  // Future<void> syncFile(String path) async {
  //   // save(settings, path)
  // }

  Setting getByNameFromFile(String name) {
    return data.firstWhere((element) => element.name == name);
  }

  Setting getByName(String name) {
    return data.firstWhere((element) => element.name == name);
  }
}
