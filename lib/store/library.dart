import 'package:mangakolekt/models/library.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'library.g.dart';

// This is the class used by rest of your codebase
class LibraryStore = LibraryBase with _$LibraryStore;

// The store-class
abstract class LibraryBase with Store {
  @observable
  String searchTerm = '';

  @observable
  int selectedCoverIndex = 0;

  @observable
  ObservableList<LibraryElement> library = ObservableList.of([]);

  @action
  void setLibrary(List<LibraryElement> lib) {
    library = ObservableList.of(lib);
  }

  @action
  void selectCover(int index) {
    selectedCoverIndex = index;
  }

  @action
  void search(String term) {
    searchTerm = term;
  }
}
