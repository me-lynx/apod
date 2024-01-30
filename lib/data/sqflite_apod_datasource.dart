import 'package:apod/cache_exception.dart';
import 'package:apod/data/apod_local_datasource.dart';
import 'package:apod/models/apod.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteAPODDataSource implements ApodLocalDataSource {
  final Database database;

  SqfliteAPODDataSource({required this.database});

  @override
  Future<Apod> getApod(String date) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'APOD',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (maps.isNotEmpty) {
      return Apod(
        title: maps[0]['title'],
        explanation: maps[0]['explanation'],
        url: maps[0]['url'],
        date: maps[0]['date'],
        path: maps[0]['path'],
      );
    } else {
      throw CacheException('No APOD found for this date');
    }
  }

  @override
  Future<void> saveApod(Apod apod) async {
    await database.insert(
      'APOD',
      apod.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
