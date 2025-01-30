import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/settings.dart';
import 'package:mangakolekt/widgets/settings/checkbox.dart';

class SettingsMobile extends StatefulWidget {
  const SettingsMobile({super.key});

  @override
  State<SettingsMobile> createState() => _SettingsMobileState();
}

class _SettingsMobileState extends State<SettingsMobile> {
  final _settingsService = locator<Settings>();

  Future<void> handleResetToDefaults()async{
    await Settings.resetSettingsToDefault();
    setState(() {
      _settingsService.data = Settings.defaultConfig().data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){handleResetToDefaults();}, icon: const Icon(Icons.restart_alt))
        ],
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            padding: const EdgeInsets.only(left: 10),
            children: const [
              SettingsCheckbox(
                name: "RTL",
              ),
              SettingsCheckbox(
                name: "doublePage",
              ),
              SettingsCheckbox(name:"showControlBar"),
            ],
          ),
        ),
      ),
    );
  }
}
