part of ffi_service;

List<FFICoverOutputResult> ffiUnzipCovers(List<dynamic> props) {
  List<String> files = props[0];
  String out = props[1];
  // List<FFICoverOutputResult> covers = [];
  final start = DateTime.now().millisecondsSinceEpoch;

  // final start = DateTime.now().millisecondsSinceEpoch;
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
