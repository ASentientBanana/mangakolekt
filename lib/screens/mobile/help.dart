import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/buttons/squareButton.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreenMobile extends StatelessWidget {
  HelpScreenMobile({super.key});
  final url = Uri.parse("https://mangakolekt.com");

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 550,
            child: Image.asset("assets/images/dog_color.png"),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text('A manga reader for reading .cbz manga files.'),
          ),
          Container(
            padding: const EdgeInsets.only(top: 54),
            child: Column(
              children: [
                SquareButton(
                  backgroundColor: colorScheme.onPrimary,
                  onPressed: () async {
                    try {
                      await launchUrl(url);
                    } catch (e) {}
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "Site",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
