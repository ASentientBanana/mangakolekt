import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/settings.dart';
import 'package:mangakolekt/widgets/settings/checkbox.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({Key? key}) : super(key: key);

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}
/*
beta: Settings

default double-page,
default direction,


*/

class _SettingsContentState extends State<SettingsContent> {
  final settingsService = locator<Settings>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(left: 10),
        children: [
          SettingsCheckbox(
            name: "RTL",
          ),
          SettingsCheckbox(
            name: "doublePage",
          )
        ],
      ),
    );
  }
}

// Checkbox(
//       checkColor: Colors.white,
//       fillColor: MaterialStateProperty.resolveWith(getColor),
//       value: isChecked,
//       onChanged: (bool? value) {
//         setState(() {
//           isChecked = value!;
//         });
//       },
//     )
