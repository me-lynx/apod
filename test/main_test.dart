import 'package:apod/apod_hive.dart';
import 'package:apod/presentation/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:apod/main.dart';

void main() {
  group('Main', () {
    setUpAll(() async {
      await initializeDateFormatting('pt_BR', null);
      await Hive.initFlutter();
      Hive.registerAdapter(ApodHiveAdapter());
    });

    testWidgets('MyApp widget is rendered', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('HomePage widget is rendered', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
