import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/widgets/buttons/squareButton.dart';

class HelpBody extends StatelessWidget {
  HelpBody({Key? key}) : super(key: key);
  final _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.primary,
      height: 450,
      width: 650,
      child: Stack(
        children: [
          Positioned(
              top: -180,
              left: 50,
              child: SizedBox(
                width: 550,
                child: Image.asset("assets/images/FullLogo.png"),
              )),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 98),
              child: Text('A manga reader for reading .cbz manga files.'),
            ),
          ),
          Positioned(
              width: 650,
              bottom: 30,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //TODO: Add in when site is ready
                    // Expanded(
                    //     // flex: 1,
                    //     child: SquareButton(
                    //   backgroundColor: colorScheme.onPrimary,
                    //   onPressed: () {},
                    //   child: const Text(
                    //     "Donate",
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    // )),
                    const SizedBox(width: 20),
                    Expanded(
                      // flex: 1,

                      child: SquareButton(
                        backgroundColor: colorScheme.onPrimary,
                        onPressed: () {},
                        child: const Text(
                          "Site",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              right: 12,
              top: 8,
              child: InkWell(
                onTap: () {
                  _navigationService.goBack();
                },
                child: Icon(
                  Icons.close,
                  color: colorScheme.tertiary,
                  size: 30,
                ),
              ))
        ],
      ),
    );
  }
}
