import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/reader.dart';

class ListPreview extends StatelessWidget {
  final ScrollController scrollController;
  final void Function(int index)? onTap;
  final ReaderController readerController;

  const ListPreview(
      {super.key,
      required this.scrollController,
      required this.readerController,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      trackVisibility: true,
      radius: Radius.zero,
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        children: readerController.pages.asMap().entries.map(
          (e) {
            final isSelected = readerController
                .getCurrentPages()
                .any((element) => (e.value.index == element));

            return Padding(
                padding: EdgeInsets.only(
                    bottom: isSelected &&
                            e.value.index !=
                                readerController.getCurrentPages().last
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
                          if (onTap != null) {
                            onTap!(e.value.index);
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
