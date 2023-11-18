import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'dart:io';

import 'package:mangakolekt/services/navigation_service.dart';

class GridItem extends StatefulWidget {
  final BookCover item;
  const GridItem({Key? key, required this.item}) : super(key: key);

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isHovering = false;
  final _navigationService = locator<NavigationService>();

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
            _navigationService.navigateTo('/reader',
                {"path": widget.item.bookPath, "id": widget.item.id});
            // Navigator.pushNamed(context, '/reader', arguments: );
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
