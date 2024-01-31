import 'package:apod/models/apod.dart';
import 'package:apod/data/apod_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApodRemoteDataSource', () {
    late ApodRemoteDataSource dataSource;

    setUp(() {
      dataSource = ApodRemoteDataSource();
    });

    test('getApods() returns a list of Apod objects', () async {
      final startDate = DateTime(2022, 1, 1);
      final endDate = DateTime(2022, 1, 5);

      final apods = await dataSource.getApods(startDate, endDate);

      expect(apods, isA<List<Apod>>());
      expect(apods.length, 5);
    });

    test('getApods() throws an exception when API request fails', () async {
      final startDate = DateTime(2022, 1, 10);
      final endDate = DateTime(2022, 1, 5);

      expect(
        () => dataSource.getApods(startDate, endDate),
        throwsA(isA<Exception>()),
      );
    });
  });
}
