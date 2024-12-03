import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/settings.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/widgets/modals/settings/contentContainer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SettingsBody extends StatelessWidget {
  final void Function() dismissCb;
  final _navigationService = locator<NavigationService>();
  final _settingsService = locator<Settings>();

  SettingsBody({Key? key, required this.dismissCb}) : super(key: key);

  void handleOnSave() async {
    final docsDir = await getApplicationDocumentsDirectory();

    await Settings.save(_settingsService,
        path: join(docsDir.path, 'mangakolekt', 'settings.json'));
    _navigationService.goBack();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(
          height: 500,
          width: 700,
          color: colorScheme.primary,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    color: colorScheme.tertiary,
                    child: const Text(
                      "General",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
              const SettingsContent()
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle().copyWith(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      backgroundColor:
                          WidgetStatePropertyAll(colorScheme.tertiary),
                    ),
                    onPressed: handleOnSave,
                    child: const Center(
                      child: Text(
                        "Save",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle().copyWith(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      backgroundColor:
                          WidgetStatePropertyAll(colorScheme.onPrimary),
                    ),
                    onPressed: () {
                      _navigationService.goBack();
                    },
                    child: const Center(
                      child: Text(
                        "Close",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
