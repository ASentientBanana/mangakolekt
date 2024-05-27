class FFICoverResult {
  List<FFICoverElement> files = [];

  FFICoverResult? fromJSON(dynamic json) {
    final ffiCoverResult = FFICoverResult();
    if (json.files == null) {
      return null;
    }
    final files = json.files as List<Map>;
    ffiCoverResult.files = files
        .map((file) => FFICoverElement(
            archiveName: file["archiveName"],
            destinationPath: file["destinationPath"],
            directoryFile: file["directoryFile"]))
        .toList();
    return ffiCoverResult;
  }
}

class FFICoverElement {
  final String archiveName;
  final String destinationPath;
  final String directoryFile;

  const FFICoverElement(
      {required this.archiveName,
      required this.destinationPath,
      required this.directoryFile});
}
