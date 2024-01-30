import 'package:apod/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await openDatabase(
    join(await getDatabasesPath(), 'apod_database.db'),
    version: 2,
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE APOD(title TEXT, explanation TEXT, url TEXT, date TEXT, path TEXT)",
      );
    },
  );

  initializeDateFormatting('pt_BR', null);

  runApp(MyApp(
    database: database,
  ));
}

class MyApp extends StatelessWidget {
  final Database database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APOD Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        database: database,
      ),
    );
  }
}
