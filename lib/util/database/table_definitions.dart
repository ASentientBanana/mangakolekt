import 'package:mangakolekt/util/database/databaseTable.dart';

final databaseTableDefinitions = [
  //Main manga table
  DatabaseTable(name: DatabaseTables.Library)
      .addPrimaryKey()
      .add(
        DatabaseTableField(
          name: 'name',
          type: DatabaseTypes.Text,
          // extra: ['unique'],
        ),
      )
      .add(DatabaseTableField(name: "path", type: DatabaseTypes.Text)),
  // .add(DatabaseTableField(name: 'path', type: DatabaseTypes.Text)),
  //Manga map table Library
  DatabaseTable(name: DatabaseTables.Book)
      .addPrimaryKey()
      .add(DatabaseTableField(name: "name", type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: "path", type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: "cover", type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: "library", type: DatabaseTypes.Int)),
  // Reader table
  DatabaseTable(name: DatabaseTables.Reader)
      .addPrimaryKey()
      .add(DatabaseTableField(name: 'page', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'path', type: DatabaseTypes.Int)),
  // Bookmarks table
  DatabaseTable(name: DatabaseTables.Bookmarks)
      .addPrimaryKey()
      .add(DatabaseTableField(name: 'book', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'page', type: DatabaseTypes.Int))
      .add(DatabaseTableField(name: 'path', type: DatabaseTypes.Text))
      .add(DatabaseTableField(name: 'created_at', type: DatabaseTypes.Int))
];
