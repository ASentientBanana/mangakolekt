import 'package:flutter/material.dart';
import 'package:mangakolekt/models/util.dart';

class SingleImage extends StatefulWidget {
  final Image image;
  final ScaleTo scaleTo;
  final int index;
  final bool isDouble;
  final ScrollController readerScrollController;
  const SingleImage(
      {super.key,
      required this.readerScrollController,
      required this.isDouble,
      required this.image,
      required this.scaleTo,
      required this.index});

  @override
  _SingleImageState createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> {
  // final _imageScrollController = widget.readerScrollController;

  @override
  void dispose() {
    widget.readerScrollController.dispose();
    super.dispose();
  }

  Alignment setAliment(bool isDouble, int index) {
    if (!isDouble) {
      return Alignment.center;
    }
    // This is to keep the images together when in double page view
    return index == 0 ? Alignment.centerRight : Alignment.centerLeft;
  }

  @override
  Widget build(BuildContext context) {
    //Check scaling type
    if (!widget.isDouble && widget.scaleTo == ScaleTo.width) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          controller: widget.readerScrollController,
          child: Image(image: widget.image.image, fit: BoxFit.cover),
        ),
      );
    }
    return Container(
      //Colors for debug purposes
      // color: widget.index == 0 ? Colors.blue : Colors.red,
      alignment: setAliment(widget.isDouble, widget.index),
      child: widget.image,
    );
  }
}
