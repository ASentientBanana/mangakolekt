import 'package:mangakolekt/util/database/database_table.dart';

final databaseTableDefinitions = [
  //Main manga table
  DatabaseTable(name: DatabaseTables.Library)
      .addPrimaryKey()
      .add(
        DatabaseTableField(
          name: 'name',
          type: DatabaseTypes.Text,
          extra: ['unique'],
        ),
      )
      .add(DatabaseTableField(name: 'path', type: DatabaseTypes.Text)),
  //Manga map table Library
  DatabaseTable(name: DatabaseTables.MangaMap)
      .add(DatabaseTableField(name: "name", type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: "path", type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: "bookPath", type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: "manga_id", type: DatabaseTypes.Int)),
  // Reader table
  DatabaseTable(name: DatabaseTables.Reader)
      .addPrimaryKey()
      .add(DatabaseTableField(name: 'currentPage', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'updated_at', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'manga', type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: 'name', type: DatabaseTypes.Text)),
  // Bookmarks table
  DatabaseTable(name: DatabaseTables.Bookmarks)
      .addPrimaryKey()
      .add(DatabaseTableField(name: 'manga', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'page', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'book', type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: 'created_at', type: DatabaseTypes.Int))
];
