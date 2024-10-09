import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt_archive_lib/mangakolekt_archive_zip/mangakolekt_archive_cover.dart';

List<FFICoverOutputResult> ffiUnzipCovers(List<dynamic> props) {
  List<String> files = props[0];
  String out = props[1];

  final covers = mangakolektUnzipArchiveCover(files, out);

  return covers
      .map(
        (cover) => FFICoverOutputResult(
            archiveName: cover.archiveName,
            directoryFile: cover.directoryFile,
            destinationPath: cover.destinationPath),
      )
      .toList();
}
