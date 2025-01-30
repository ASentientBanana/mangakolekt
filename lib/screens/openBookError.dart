import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';

class OpenBookError extends StatelessWidget {
  OpenBookError({super.key});
  final _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
          onTap: () => _navigationService.pushAndPop('/home', null),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Unable to open book',
                  style: TextStyle(color: Colors.grey[400], fontSize: 25),
                ),
                Text(
                  'Click to go back',
                  style: TextStyle(color: Colors.grey[400], fontSize: 17),
                )
              ],
            ),
          )),
    );
  }
}
