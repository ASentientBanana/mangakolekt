import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/settings/checkbox.dart';

class SettingsMobile extends StatelessWidget {
  const SettingsMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            padding: const EdgeInsets.only(left: 10),
            children: [
              SettingsCheckbox(
                name: "RTL",
              ),
              SettingsCheckbox(
                name: "doublePage",
              ),
              SettingsCheckbox(
                name: "showControlBar",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
