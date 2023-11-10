import 'package:flutter/material.dart';
import 'package:mangakolekt/models/util.dart';

class SingleImage extends StatefulWidget {
  final Image image;
  final ScaleTo scaleTo;
  final int index;
  final bool isDouble;
  const SingleImage(
      {super.key,
      required this.isDouble,
      required this.image,
      required this.scaleTo,
      required this.index});

  @override
  _SingleImageState createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> {
  final _imageScrollController = ScrollController();

  @override
  void dispose() {
    _imageScrollController.dispose();
    super.dispose();
  }

  Alignment setAliment(bool isDouble, int index) {
    if (!isDouble) {
      return Alignment.center;
    }
    return index == 0 ? Alignment.centerRight : Alignment.centerLeft;
  }

  @override
  Widget build(BuildContext context) {
    final Widget img = widget.scaleTo == ScaleTo.height
        ? Container(
            color: Colors.amber,
            alignment: setAliment(widget.isDouble, widget.index),
            child: widget.image,
          )
        : SingleChildScrollView(
            controller: _imageScrollController,
            child: Image(image: widget.image.image, fit: BoxFit.cover),
          );
    return Container(child: img);
  }
}
