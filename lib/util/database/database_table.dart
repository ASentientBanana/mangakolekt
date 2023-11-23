class DatabaseTable {
  final String name;
  final List<DatabaseTableField> fields = [];

  DatabaseTable({
    required this.name,
  });

  DatabaseTable add(DatabaseTableField dbField) {
    fields.add(dbField);
    return this;
  }

  DatabaseTable addPrimaryKey() {
    fields.add(DatabaseTableField(
        name: "id", type: DatabaseTypes.Int, extra: ["primary", "key"]));
    return this;
  }

  String build() {
    return "CREATE TABLE IF NOT EXISTS $name (${fields.join(', ')})";
  }
}

class DatabaseTableField {
  late final String name;
  late final String type;
  List<String> extra = [];

  DatabaseTableField(
      {required this.name, required this.type, List<String>? extra}) {
    if (extra != null) {
      this.extra = extra;
    }
  }

  DatabaseTableField.FK({required name, required String table}) {
    type = '';

    this.name =
        "FOREIGN KEY($name) REFERENCES $table(id) ON DELETE NO ACTION ON UPDATE NO ACTION";
  }

  @override
  String toString() {
    return "$name ${type.toUpperCase()} ${extra.join(' ').toUpperCase()}";
  }
}

class DatabaseTables {
  static String Manga = "Manga";
  static String MangaMap = "MangaMap";
  static String Reader = "Reader";
  static String Bookmarks = "Bookmarks";
}

class DatabaseTypes {
  static String Blob = 'BLOB';
  static String Null = 'NULL';
  static String Int = 'INTEGER';
  static String Real = 'REAL';
  static String Text = 'TEXT';
}
