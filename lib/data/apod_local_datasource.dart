import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../apod_hive.dart';

class ApodLocalDataSource {
  final String _boxName = 'apodBox';

  Future<void> saveApods(List<ApodHive> apods) async {
    final box = await Hive.openBox<ApodHive>(_boxName);
    for (var apod in apods) {
      await box.put(apod.date, apod);
    }
  }

  Future<List<ApodHive>> getApods() async {
    try {
      final box = await Hive.openBox<ApodHive>(_boxName);
      return box.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao abrir a caixa Hive: $e');
      }
      return [];
    }
  }
}
