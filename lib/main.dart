import 'package:apod/data/apod_remote_datasource.dart';
import 'package:apod/database_service.dart';
import 'package:apod/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<ApodRemoteDataSource>(ApodRemoteDataSource());

  getIt.registerSingleton<DatabaseService>(
    DatabaseService(),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService databaseService = await DatabaseService().init();

  initializeDateFormatting('pt_BR', null);

  runApp(MyApp(
    databaseService: databaseService,
  ));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;
  const MyApp({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APOD Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        database: databaseService,
      ),
    );
  }
}
