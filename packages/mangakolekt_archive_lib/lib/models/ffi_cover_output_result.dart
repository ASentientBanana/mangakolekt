class FFILibCoverOutputResult {
  final String archiveName;
  final String destinationPath;
  final String directoryFile;
  FFILibCoverOutputResult(
      {required this.archiveName,
      required this.directoryFile,
      required this.destinationPath});
  static FFILibCoverOutputResult? fromMap(Map<String, dynamic> map) {
    const fields = ["archiveName", "destinationPath", "directoryFile"];
    bool isValid = true;
    for (var element in fields) {
      if (map[element] == null) {
        isValid = false;
      }
    }

    if (!isValid) {
      return null;
    }
    return FFILibCoverOutputResult(
        archiveName: map["archiveName"]!,
        directoryFile: map["directoryFile"]!,
        destinationPath: map["destinationPath"]!);
  }
}
