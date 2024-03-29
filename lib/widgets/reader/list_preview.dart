import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/reader.dart';

class ListPreview extends StatefulWidget {
  final void Function(int index)? onTap;
  final ReaderController readerController;
  ScrollController scrollController = ScrollController();

  ListPreview(
      {super.key,
      required this.readerController,
      required this.onTap,
      ScrollController? sc}) {
    if (sc != null) {
      scrollController = sc;
    }
  }

  @override
  State<ListPreview> createState() => _ListPreviewState();
}

class _ListPreviewState extends State<ListPreview> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = widget.readerController.getCurrentPages().first;
      const int offset = 4;
      const int pageImageHeight = 130;
      if (widget.scrollController.positions.isNotEmpty) {
        widget.scrollController.animateTo(
            ((index - offset) * pageImageHeight).toDouble(),
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      trackVisibility: true,
      radius: Radius.zero,
      controller: widget.scrollController,
      child: ListView(
        controller: widget.scrollController,
        children: widget.readerController.pages.asMap().entries.map(
          (e) {
            final isSelected = widget.readerController
                .getCurrentPages()
                .any((element) => (e.value.index == element));

            return Padding(
                padding: EdgeInsets.only(
                    bottom: isSelected &&
                            e.value.index !=
                                widget.readerController.getCurrentPages().last
                        ? 0
                        : 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: isSelected
                          ? Theme.of(context).colorScheme.tertiary
                          : Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (widget.onTap != null) {
                            widget.onTap!(e.value.index);
                          }
                        },
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: FractionallySizedBox(
                            heightFactor: 1,
                            // height: 100,
                            child: Center(
                              child: Container(
                                  padding: EdgeInsets.all(isSelected ? 3 : 0),
                                  child: e.value.entry.image),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text("${e.key + 1}"),
                    ),
                  ],
                ));
          },
        ).toList(),
      ),
    );
  }
}
