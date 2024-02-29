import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/settings.dart';

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
  final settingsService = locator<SettingsService>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Row(children: [
              Row(
                children: [
                  const Text("Double page"),
                  Checkbox(
                    checkColor: colorScheme.tertiary,
                    fillColor:
                        MaterialStateProperty.all(colorScheme.background),
                    value: settingsService.settings.isDoublePageView,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == null) {
                          return;
                        }
                        settingsService.settings.isDoublePageView = value;
                      });
                    },
                  )
                ],
              ),
              VerticalDivider(
                width: 10,
              ),
              Row(
                children: [
                  const Text("Right to left page"),
                  Checkbox(
                    checkColor: colorScheme.tertiary,
                    fillColor:
                        MaterialStateProperty.all(colorScheme.background),
                    value: settingsService.settings.isRtL,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == null) {
                          return;
                        }
                        settingsService.settings.isRtL = value;
                      });
                    },
                  )
                ],
              ),
            ]),
          ),
          Divider(
            color: colorScheme.secondary,
          ),
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
