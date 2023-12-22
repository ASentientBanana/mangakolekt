import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigation_service.dart';

class CustomBackButton extends StatelessWidget {
  CustomBackButton({Key? key}) : super(key: key);

  final _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _navigationService.goBack();
      },
      child: const Center(
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
