import 'package:apod/database_service.dart';
import 'package:apod/models/apod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  group('DatabaseService', () async {
    late DatabaseService databaseService;
    late MockDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockDatabase();
      databaseService = DatabaseService();
      databaseService.database = mockDatabase;
    });

    test('getApods returns list of Apod when called', () async {
      final mockResult = [
        {
          'id': 1,
          'title': 'Test Title',
          'explanation': 'Test Explanation',
          'url': 'Test Url',
          'date': '2022-01-01',
          'path': 'Test Path'
        }
      ];

      final startDate = DateTime(2022, 01, 01);
      final endDate = DateTime(2022, 01, 31);

      when(mockDatabase.query(
        'APOD',
        where: 'date BETWEEN ? AND ?',
        whereArgs: ['2022-01-01', '2022-01-31'],
      )).thenAnswer((_) async => mockResult);

      final result = await databaseService.getApods(startDate, endDate);

      expect(result, isInstanceOf<List<Apod>>());
      expect(result.first, isInstanceOf<Apod>());
      expect(result.first.title, 'Test Title');
      expect(result.first.explanation, 'Test Explanation');
      expect(result.first.url, 'Test Url');
      expect(result.first.date, '2022-01-01');
      expect(result.first.path, 'Test Path');
    });

    test('saveImage inserts data into the database', () async {
      final title = 'Test Title';
      final explanation = 'Test Explanation';
      final url = 'Test Url';
      final date = '2022-01-01';
      final path = 'Test Path';

      when(mockDatabase.insert(
        'APOD',
        {
          'title': title,
          'explanation': explanation,
          'url': url,
          'date': date,
          'path': path,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      )).thenAnswer((_) async => 1);

      await databaseService.saveImage(title, explanation, url, date, path);

      verify(mockDatabase.insert(
        'APOD',
        {
          'title': title,
          'explanation': explanation,
          'url': url,
          'date': date,
          'path': path,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      )).called(1);
    });

    test('close closes the database', () async {
      when(mockDatabase.close()).thenAnswer((_) async => null);

      await databaseService.close();

      verify(mockDatabase.close()).called(1);
    });
  });
}
