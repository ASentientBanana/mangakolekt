import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'dart:io';

class GridItem extends StatelessWidget {
  final BookCover item;
  const GridItem({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Center(
        child: Text(item.name),
      ),
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/reader', arguments: item.bookPath);
          },
          child: Image.file(
            fit: BoxFit.contain,
            File(item.path),
          ),
        ),
      ),
    );
  }
}
