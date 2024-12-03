import 'dart:convert';
import 'dart:io';

import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
      Setting(
          type: 'bool', name: "showControlBar", description: "Default to show UI reader control bar", value: false),
    ];
  }

  static Future<File?> loadSettingsFile(String path) async {
    final file = File(join(path, 'settings.json'));
    if (await file.exists()) {
      return null;
    }
    return file;
  }

  static Future<List<Setting>> load({String? path, File? file}) async {
    if (file == null && path == null) {
      throw Exception('File or path must be provided.');
    }
    final File file0;

    if (file != null) {
      file0 = file;
    } else {
      file0 = File(path!);
    }
    // final file = File(path);
    if (!(await file0.exists())) {
      return [];
    }
    final map = await file0.readAsString();
    final jsonData = jsonDecode(map) as List<dynamic>;
    final data = jsonData
        .map((map) => Setting.fromMap(map))
        .where((element) => element.value != null)
        .toList();

    return data;
  }

  static Future<void> save(Settings settings,
      {String? path, File? file}) async {
    if (file == null && path == null) {
      throw Exception("File or path must be provided.");
    }
    final File file0;

    if (file != null) {
      file0 = file;
    } else {
      file0 = File(path!);
    }
    // final file = File(path);
    if (!await file0.exists()) {
      return;
    }
    final map = settings.data
        .map((e) => {
              "type": e.type,
              "name": e.name,
              "description": e.description,
              "value": e.value
            })
        .toList();
    final jsonString = jsonEncode(map);
    await file0.writeAsString(jsonString);
  }

  static Future<void> init() async {
    final settingsService = locator<Settings>();
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File(join(path, 'mangakolekt', 'settings.json'));
    if (!(await file.exists())) {
      await file.create();
      await save(Settings.defaultConfig(), file: file);
      return;
    }

    final fSettings = await load(file: file);
    print("loading settings into mem");
    settingsService.data = fSettings;
  }

  static Future<File> getSettingsFile()async{
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File(join(path, 'mangakolekt', 'settings.json'));
    return file;
  }

  static Future<void> resetSettingsToDefault()async{
    final file = await getSettingsFile();
    await Settings.save(Settings.defaultConfig(), file: file);
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

  int getIndexByName(String name) {
    return data.indexWhere((element) {
      print("Looking for $name comparing to ${element.name}");
      return element.name == name;
    });
  }
}
