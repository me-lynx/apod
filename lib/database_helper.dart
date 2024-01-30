import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'apod_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE APOD(title TEXT, explanation TEXT, url TEXT, date TEXT, path TEXT)",
        );
      },
      version: 1,
    );
  }
}
