import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/util/platform.dart';
import 'package:mangakolekt/util/reader.dart';

class SingleImage extends StatefulWidget {
  const SingleImage(
      {super.key,
      required this.isDouble,
      required this.imageIndex,
      required this.size,
      required this.image,
      this.increment,
      this.onDrag});
  final void Function(PointerDownEvent)? increment;
  final void Function(DragEndDetails details)? onDrag;
  final Size size;
  final int imageIndex;
  final Image image;
  final bool isDouble;

  @override
  _SingleImageState createState() => _SingleImageState();
}

const double tagOffset = 10;

class _SingleImageState extends State<SingleImage> {
  final ScrollController scrollController = ScrollController();
  bool isDoubleTouch = false;
  @override
  Widget build(BuildContext context) {
    Widget image;

    if (widget.isDouble) {
      image = Image(
          fit: BoxFit.fitWidth,
          alignment: setAliment(widget.isDouble, widget.imageIndex),
          // alignment: Alignment.center,
          height: widget.size.height,
          width: widget.size.width,
          image: widget.image.image);
    } else {
      //TODO: Add width/height scaling
      image = Image(
        alignment: Alignment.center,
        height: widget.size.height,
        width: widget.size.width,
        image: widget.image.image,
      );
    }

    if (isMobile()) {
      return GestureDetector(
        onVerticalDragEnd: widget.onDrag,
        child: image,
      );
    }

    final tag = kDebugMode
        ? Positioned(
            right: widget.imageIndex == 0 ? tagOffset : null,
            left: widget.imageIndex == 1 ? tagOffset : null,
            top: 0,
            child: Container(
              color: const Color.fromARGB(166, 0, 0, 0),
              child: Text("w:${widget.image.width}x${widget.image.height}"),
            ),
          )
        : SizedBox.shrink();

    return (Listener(
      onPointerDown: widget.increment,
      child: Stack(
        children: [image, tag],
      ),
    ));
  }
}
