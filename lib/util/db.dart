import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteBase {
  static Database? db;

  Future<Database?> get database async {
    if (db != null) {
      return db;
    } else {
      db = await initDb();
      return db;
    }
  }

  Future initDb() async {
    var dbPath = await getDatabasesPath();

    String path = join(dbPath, 'tkita_v2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {}
}
