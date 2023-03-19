import 'dart:async';

// enum LibraryEvents { Select }

class LibraryBloc {
  String selectedLib = '';
  final _blocCounterControler = StreamController<String>.broadcast();

  StreamSink<String> get libSink => _blocCounterControler.sink;
  Stream<String> get libStream => _blocCounterControler.stream;

  // final _eventStreamControler = StreamController<LibraryEvents>();
  // StreamSink<LibraryEvents> get libEventSink => _eventStreamControler.sink;
  // Stream<LibraryEvents> get libEventStream => _eventStreamControler.stream;

  LibraryBloc() {
    print("Created bloc");
    libStream.listen((event) {
      print("Listening to::");
      print(event);
    });

    //   libEventStream.listen((event) {
    //     if (event == LibraryEvents.Select) {
    //       print("");
    //     }
    //     libEventSink.add(LibraryEvents.Select);
    //   });
  }

  void dispose() {
    // counterSink.
    libSink.close();

    _blocCounterControler.close();
    // _eventStreamControler.close();
  }
}
