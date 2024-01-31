import 'package:flutter_test/flutter_test.dart';
import 'package:apod/models/apod.dart';

void main() {
  group('Apod', () {
    final json = {
      'title': 'Test Title',
      'explanation': 'Test Explanation',
      'url': 'Test Url',
      'date': '2022-01-01',
    };

    final map = {
      'title': 'Test Title',
      'explanation': 'Test Explanation',
      'url': 'Test Url',
      'date': '2022-01-01',
      'path': 'Test Path',
    };

    test('fromJson creates an instance of Apod from a JSON object', () {
      final result = Apod.fromJson(json);

      expect(result, isInstanceOf<Apod>());
      expect(result.title, 'Test Title');
      expect(result.explanation, 'Test Explanation');
      expect(result.url, 'Test Url');
      expect(result.date, '2022-01-01');
      expect(result.path, null);
    });

    test('fromMap creates an instance of Apod from a map', () {
      final result = Apod.fromMap(map);

      expect(result, isInstanceOf<Apod>());
      expect(result.title, 'Test Title');
      expect(result.explanation, 'Test Explanation');
      expect(result.url, 'Test Url');
      expect(result.date, '2022-01-01');
      expect(result.path, 'Test Path');
    });

    test('toMap creates a map from an instance of Apod', () {
      final apod = Apod.fromMap(map);
      final result = apod.toMap();

      expect(result, map);
    });
  });
}
