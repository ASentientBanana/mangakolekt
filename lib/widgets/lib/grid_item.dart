import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'dart:io';

class GridItem extends StatefulWidget {
  final BookCover item;
  const GridItem({Key? key, required this.item}) : super(key: key);

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridTile(
      footer: Center(
        child: Text(widget.item.name),
      ),
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: InkWell(
          onHover: (_isHovering) {
            setState(() {
              isHovering = _isHovering;
            });
          },
          onTap: () {
            Navigator.pushNamed(context, '/reader',
                arguments: widget.item.bookPath);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: theme.colorScheme.tertiary,
              border: isHovering
                  ? Border.all(
                      color: theme.colorScheme.primary,
                      style: BorderStyle.solid,
                      width: 3)
                  : null,
            ),
            child: Image.file(
              fit: BoxFit.contain,
              File(widget.item.path),
            ),
          ),
        ),
      ),
    );
  }
}
