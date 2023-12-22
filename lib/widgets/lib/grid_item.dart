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

class _GridItemState extends State<GridItem> with TickerProviderStateMixin {
  bool isHovering = false;
  final _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GridTile(
      footer: Center(
        child: Container(
          padding: EdgeInsets.only(top: 100),
          child: Text(widget.item.name),
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // foregroundDecoration: BoxDecoration(
        //   border: isHovering
        //       ? Border(
        //           bottom: BorderSide(width: 20, color: colorScheme.primary))
        //       : null,
        // ),
        // color: isHovering ? colorScheme.secondary : Colors.transparent,
        padding: EdgeInsets.all(isHovering ? 20 : 50),
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
          // padding: const EdgeInsets.all(10),
          child: Image.file(
            fit: BoxFit.contain,
            File(widget.item.path),
          ),
        ),
      ),
    );
  }
}
