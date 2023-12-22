import 'package:mangakolekt/util/database/database_table.dart';

final databaseTableDefinitions = [
  //Main manga table
  DatabaseTable(name: DatabaseTables.Manga)
      .addPrimaryKey()
      .add(
        DatabaseTableField(
          name: 'name',
          type: DatabaseTypes.Text,
          extra: ['unique'],
        ),
      )
      .add(DatabaseTableField(name: 'path', type: DatabaseTypes.Text)),
  //Manga map table
  DatabaseTable(name: DatabaseTables.MangaMap)
      .add(DatabaseTableField(name: "name", type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: "path", type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: "bookPath", type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: "manga_id", type: DatabaseTypes.Int)),
  // Reader table
  DatabaseTable(name: DatabaseTables.Reader)
      .addPrimaryKey()
      .add(DatabaseTableField(name: 'doublePageView', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'currentPage', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'manga', type: DatabaseTypes.Text)),
  DatabaseTable(name: DatabaseTables.Bookmarks)
      .add(DatabaseTableField(name: 'manga', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'page', type: DatabaseTypes.Int))
];
