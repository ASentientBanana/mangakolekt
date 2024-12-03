import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'dart:io';

import 'package:mangakolekt/services/navigationService.dart';

class GridItem extends StatefulWidget {
  final BookCover item;
  final int libraryId;
  const GridItem({Key? key, required this.item, this.libraryId = -1})
      : super(key: key);

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> with TickerProviderStateMixin {
  bool isHovering = false;
  final _navigationService = locator<NavigationService>();

  Widget imageBuilder(BuildContext context, AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
      return Image.asset('assets/images/dog_color.png');
    }
    return snapshot.data;
  }

  Future<Widget> loadImage(BookCover cover) async {
    final coverFile = File(await cover.getPath());

    if (!await coverFile.exists()) {
      return Image.asset('assets/images/dog_color.png');
    }

    return Image.file(
      coverFile,
      errorBuilder: (_, __, ___) {
        return Image.asset('assets/images/dog_color.png');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    return GridTile(
      footer: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 100),
          child: Text(widget.item.name),
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isHovering ? 20 : 50),
        child: InkWell(
          hoverColor: Colors.transparent,
          onHover: (isHovering) {
            setState(() {
              isHovering = isHovering;
            });
          },
          onTap: () {
            // print(widget.libraryId);
            _navigationService.navigateTo('/reader', {
              "path": widget.item.bookPath,
              "id": widget.item.id,
              "libraryId": widget.libraryId
            });
          },
          child: FutureBuilder<Widget>(
            builder: imageBuilder,
            future: loadImage(widget.item),
          ),
        ),
      ),
    );
  }
}
