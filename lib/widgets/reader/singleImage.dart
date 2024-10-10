import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/util/platform.dart';
import 'package:mangakolekt/util/reader.dart';

class SingleImage extends StatefulWidget {

  const SingleImage({
        super.key,
        required this.isDouble,
        required this.imageIndex,
        required this.size,
        required this.image,
        this.increment,
        this.onDrag
      });
  final void Function(PointerDownEvent)? increment;
  final void Function(DragEndDetails details)? onDrag ;
  final Size size;
  final int imageIndex;
  final Image image;
  final bool isDouble;

  @override
  _SingleImageState createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> {

  final ScrollController scrollController = ScrollController();
  bool isDoubleTouch = false;

  @override
  Widget build(BuildContext context) {
    Widget _image;

    if(widget.isDouble){
      _image = Image(
          alignment: setAliment(widget.isDouble, widget.imageIndex),
          height: widget.size.height,
          width: widget.size.width,
          image: widget.image.image
      );
    }else{
      //TODO: Add width/height scaling
      _image =
        Image(
          alignment: setAliment(widget.isDouble ,widget.imageIndex),
          height: widget.size.height,
          width: widget.size.width,
          image: widget.image.image,
      );
    }

    if(isMobile()) {
      return GestureDetector(
        onVerticalDragEnd: widget.onDrag,
        child: _image,
      );
    }

    return (
        Listener(
          onPointerDown: widget.increment,
          child: _image,
        )
    );
  }
}
