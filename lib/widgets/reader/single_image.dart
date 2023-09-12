import 'package:flutter/material.dart';
import 'package:mangakolekt/models/util.dart';

class SingleImage extends StatefulWidget {
  final Image image;
  final ScaleTo scaleTo;
  const SingleImage({super.key, required this.image, required this.scaleTo});

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

  @override
  Widget build(BuildContext context) {
    final Widget img = widget.scaleTo == ScaleTo.height
        ? widget.image
        : SingleChildScrollView(
            controller: _imageScrollController,
            child: Image(image: widget.image.image, fit: BoxFit.cover),
          );
    return Container(child: img);
  }
}
