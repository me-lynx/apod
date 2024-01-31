import 'package:apod/presentation/cubits/apod_cubit.dart';
import 'package:apod/database_service.dart';
import 'package:apod/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';

class MockApodCubit extends Mock implements ApodCubit {}

class MockDatabase extends Mock implements DatabaseService {}

void main() {
  group('HomePage', () {
    late MockDatabase database;
    setUp(() {
      database = MockDatabase();

      initializeDateFormatting('pt_BR', null);
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HomePage(database: database),
      ));

      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.text('Search APODS'), findsOneWidget);
    });
  });
}
