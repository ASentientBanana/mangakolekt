// Import the test package and Counter class
import 'package:flutter_test/flutter_test.dart';
import 'package:mangakolekt/util/archive.dart';

void main() {
  test('Unzip test', () async {
    final start = DateTime.now().millisecondsSinceEpoch;
    final files = await unzipCoverBeta(
        '/home/petar/bigboy/Manga/Holyland/Holyland - Volume_01.cbz',
        '/home/petar/Projects/mangakolekt/test/out/');
    final end = DateTime.now().millisecondsSinceEpoch;
    print(files);
    print("Time: ${(end - start) / 1000}");
    // expect(,);
  });
}
