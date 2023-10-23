import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';

class ReaderPage extends StatelessWidget {
  final PageEntry item;
  final bool isDoublePageView;

  const ReaderPage(
      {Key? key, required this.item, required this.isDoublePageView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: FractionallySizedBox(
        heightFactor: 1,
        child: item.image,
      ),
    );
  }
}
