import 'dart:async';

enum CounterEvents { Add, Subtract }

class CounterBloc {
  int counter = 0;
  final _blocCounterControler = StreamController<int>();

  StreamSink<int> get counterSink => _blocCounterControler.sink;
  Stream<int> get counterStream => _blocCounterControler.stream;

  final _eventStreamControler = StreamController<CounterEvents>();
  StreamSink<CounterEvents> get eventSink => _eventStreamControler.sink;
  Stream<CounterEvents> get eventStream => _eventStreamControler.stream;

  CounterBloc() {
    eventStream.listen((event) {
      if (event == CounterEvents.Add) {
        counter++;
      }
      if (event == CounterEvents.Subtract) {
        counter--;
      }
      counterSink.add(counter);
    });
  }

  void cleanup() {
    // counterSink.
    _blocCounterControler.close();
    _eventStreamControler.close();
  }
}
