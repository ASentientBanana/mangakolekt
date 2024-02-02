import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/main.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/widgets/modals/settings/contentContainer.dart';

class SettingsBody extends StatelessWidget {
  final void Function() dismissCb;
  final _navigationService = locator<NavigationService>();

  SettingsBody({Key? key, required this.dismissCb}) : super(key: key);

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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(colorScheme.tertiary),
                    ),
                    onPressed: () {
                      _navigationService.goBack();
                    },
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(colorScheme.onPrimary),
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
