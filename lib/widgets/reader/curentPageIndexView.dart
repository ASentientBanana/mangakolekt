import 'package:flutter/material.dart';

class CurrentPageIndexView extends StatelessWidget {
  String current = '';
  String total = '';
  CurrentPageIndexView({Key? key, String? currentPages, String? totalPages})
      : super(key: key) {
    if (currentPages != null) {
      current = currentPages;
    }
    if (totalPages != null) {
      total = totalPages;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(5)),
        color: colorScheme.primary,
        border: Border.all(
          style: BorderStyle.solid,
          color: colorScheme.tertiary,
        ),
      ),
      width: 100,
      height: 30,
      child: Center(child: Text('$current/$total')),
    );
  }
}
