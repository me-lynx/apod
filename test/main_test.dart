import 'package:apod/database_service.dart';
import 'package:apod/presentation/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:apod/main.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockDatabaseService mockDatabase;

  group('Main', () {
    setUp(() {
      mockDatabase = MockDatabaseService();
    });

    setUpAll(() async {
      await initializeDateFormatting('pt_BR', null);
    });

    testWidgets('renders HomePage', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(databaseService: mockDatabase));

      expect(find.byType(HomePage), findsOneWidget);
    });
    testWidgets('HomePage widget is rendered', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(databaseService: mockDatabase));

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
