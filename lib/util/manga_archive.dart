abstract class ArchiveController {
  final List<String> fileTypes;
  final String path;

  ArchiveController({required this.path, required this.fileTypes});

  Future<List<String>> unzip();
}
