import 'dart:isolate';

import 'package:mangakolekt/models/book.dart';

class IsolateArchivePool<T> {
  final int poolSize;
  final List<String> inputs;
  final Future<Book> Function(String path) cb;
  final List<Isolate> pool = [];
  IsolateArchivePool(
      {required this.cb, required this.inputs, required this.poolSize});

  //generate isolate pool
  generate() async {
    for (var i = 0; i < poolSize; i++) {
      pool.add(await Isolate.spawn((String path) {
        ReceivePort receivePort = ReceivePort();
        receivePort.listen((message) async {
          final book = await cb(path);
          message['response'].send(book);
        });
      }, ''));
    }
  }

  Future<Book> sendReceive(SendPort sendPort, String pathMessage) async {
    ReceivePort response = ReceivePort();
    sendPort.send({'request': pathMessage, 'response': response.sendPort});
    return await response.first;
  }

  run() {}
}
