import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  late Database _database;

  Future<DatabaseService> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'apod_database.db'),
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE APOD(title TEXT, explanation TEXT, url TEXT, date TEXT, path TEXT)",
        );
      },
    );
    return this;
  }

  Future<List<String>> getApods() async {
    final List<Map<String, dynamic>> maps = await _database.query('APOD');
    return maps.map((map) => map['path'] as String).toList();
  }

  Future<void> saveImage(String title, String explanation, String url,
      String date, String path) async {
    final Map<String, dynamic> values = {
      'title': title,
      'explanation': explanation,
      'url': url,
      'date': date,
      'path': path
    };

    await _database.insert(
      'APOD',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future close() async {
    await _database.close();
  }
}
