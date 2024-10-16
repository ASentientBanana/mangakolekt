import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/settings.dart';

class SettingsCheckbox extends StatefulWidget {
  final String name;
  SettingsCheckbox({Key? key, required this.name}) : super(key: key);

  @override
  State<SettingsCheckbox> createState() => _SettingsCheckboxState();
}

class _SettingsCheckboxState extends State<SettingsCheckbox> {
  final _settingsService = locator<Settings>();
  late int? settingIndex = -1;

  @override
  void initState() {
    final _index = _settingsService.getIndexByName(widget.name);
    if(_index != -1){
      settingIndex = _index;
    }
    super.initState();
  }

  void handleChange(bool? value) {
    setState(() {
      if (settingIndex == null) {
        return;
      }
      _settingsService.data[settingIndex!].value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (settingIndex == null || settingIndex! < 0 ||
        _settingsService.data[settingIndex!].value == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Text(_settingsService.data[settingIndex!].description),
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.all(colorScheme.background),
          value: _settingsService.data.isEmpty || settingIndex == null
              ? false
              : _settingsService.data[settingIndex!].value as bool,
          onChanged: settingIndex != null ? handleChange : null,
        )
      ],
    );
  }
}
