import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/widgets/buttons/squareButton.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpBody extends StatelessWidget {
  HelpBody({super.key});
  final _navigationService = locator<NavigationService>();
  final url = Uri.parse("https://mangakolekt.com");
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
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: SquareButton(
                        backgroundColor: colorScheme.onPrimary,
                        onPressed: () async {
                          try {
                            await launchUrl(url);
                          } catch (e) {}
                        },
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
