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
    return GridTile(
      footer: Center(
        child: Text(widget.item.name),
      ),
      child: FractionallySizedBox(
        heightFactor: isHovering ? .82 : 0.8,
        widthFactor: isHovering ? .82 : 0.8,
        child: InkWell(
          hoverColor: Colors.transparent,
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
            padding: const EdgeInsets.all(10),
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
