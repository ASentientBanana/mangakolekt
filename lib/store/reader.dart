import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'reader.g.dart';

// This is the class used by rest of your codebase
class ReaderStore = ReaderBase with _$ReaderStore;

// The store-class
abstract class ReaderBase with Store {
  @observable
  ObservableList<Bookmark> bookmarks = ObservableList.of([]);
}
