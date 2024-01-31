import 'package:apod/models/apod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseService {
  late Database? database;

  Future<DatabaseService> init() async {
    database = await openDatabase(
      path.join(await getDatabasesPath(), 'apod_database.db'),
      version: 4,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE APOD(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,explanation TEXT,url TEXT, date TEXT,path TEXT)',
        );
      },
    );
    return this;
  }

  Future<List<Apod>> getApods(DateTime startDate, DateTime endDate) async {
    DateTime startDateEdited =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endDateEdited = DateTime(endDate.year, endDate.month, endDate.day);

    String startDateString =
        "${startDateEdited.year.toString().padLeft(4, '0')}-${startDateEdited.month.toString().padLeft(2, '0')}-${startDateEdited.day.toString().padLeft(2, '0')}";
    String endDateString =
        "${endDateEdited.year.toString().padLeft(4, '0')}-${endDateEdited.month.toString().padLeft(2, '0')}-${endDateEdited.day.toString().padLeft(2, '0')}";

    final List<Map<String, dynamic>> maps = await database!.query(
      'APOD',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDateString, endDateString],
    );

    return maps.map((map) => Apod.fromMap(map)).toList();
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

    await database?.insert(
      'APOD',
      values,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future close() async {
    await database?.close();
  }
}
