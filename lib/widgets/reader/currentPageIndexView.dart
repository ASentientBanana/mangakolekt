import 'package:flutter/material.dart';

class CurrentPageIndexView extends StatelessWidget {
  String current = '';
  String total = '';
  CurrentPageIndexView({super.key, String? currentPages, String? totalPages}) {
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
