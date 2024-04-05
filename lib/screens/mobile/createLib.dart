import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';

class CreateLibraryMobile extends StatelessWidget {
  final String path;
  CreateLibraryMobile({Key? key, required this.path}) : super(key: key);

  final textController = TextEditingController();

  void handleConfirm() {}

  @override
  Widget build(BuildContext context) {
    final coloScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: coloScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enter a name for the lib located at:'),
          Text(path),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
            child: TextFormField(
              controller: textController,
              showCursor: true,
              cursorColor: coloScheme.tertiary,
              decoration: InputDecoration(
                hintText: "Enter a label for the lib",
                hintStyle: TextStyle(color: Colors.white60),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(width: 1, color: coloScheme.tertiary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(width: 1, color: coloScheme.tertiary),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              // backgroundColor: colorScheme.tertiary,
              shape: const BeveledRectangleBorder(),
              // side: BorderSide(color: colorScheme.secondary)
            ),
            onPressed: () => handleConfirm(),
            child: const Text(
              "Confirm",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
