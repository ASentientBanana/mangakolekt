import 'package:mangakolekt/models/util.dart';

class BookView {
  bool isDoublePageView = false;
  bool isRightToLeftMode = false;
  ScaleTo scaleTo = ScaleTo.height;
  ReaderView readerView = ReaderView.single;
  List<int> currentPages = [];

  BookView();

  BookView.copy({
    required this.isDoublePageView,
    required this.isRightToLeftMode,
    required this.scaleTo,
    required this.readerView,
    required this.currentPages,
  });

  BookView copyWith({
    bool? isDoublePageView,
    bool? isRightToLeftMode,
    ScaleTo? scaleTo,
    ReaderView? readerView,
    List<int>? currentPages,
  }) {
    return BookView.copy(
      isDoublePageView: isDoublePageView ?? this.isDoublePageView,
      isRightToLeftMode: isRightToLeftMode ?? this.isRightToLeftMode,
      scaleTo: scaleTo ?? this.scaleTo,
      readerView: readerView ?? this.readerView,
      currentPages: currentPages ?? this.currentPages,
    );
  }
}
