import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/util/platform.dart';
import 'package:mangakolekt/widgets/modals/permissionPrompt/permissionPromptBody.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> showPermissionDialog(BuildContext context, {confirm}) async {
  if (!isMobile()) {
    return;
  }
  print("Granted: ${await Permission.manageExternalStorage.isGranted}");
  if (await Permission.manageExternalStorage.isGranted) {
    return;
  }

  final _navigationService = locator<NavigationService>();

  final isAgreed = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: const EdgeInsets.all(0),
          scrollable: true,
          actions: [
            ElevatedButton(
              onPressed: () {
                _navigationService.goBack(data: false);
              },
              child: const Text("Decline"),
            ),
            ElevatedButton(
              onPressed: () {
                _navigationService.goBack(data: true);
              },
              child: const Text("Accept"),
            )
          ],
          content: const PermissionPromptBody(),
        );
      });
  print("Is accepted: $isAgreed");
  // TODO: Add more stuff
  if (isAgreed != null && isAgreed) {}
  final result = await Permission.manageExternalStorage.request();
  if (result.isDenied || result.isPermanentlyDenied) {
    return;
  }
}
