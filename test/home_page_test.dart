import 'package:apod/cubits/apod_cubit.dart';
import 'package:apod/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';

class MockApodCubit extends Mock implements ApodCubit {}

void main() {
  group('HomePage', () {
    late MockApodCubit apodCubit;

    setUp(() {
      apodCubit = MockApodCubit();

      initializeDateFormatting('pt_BR', null);
      Hive.initFlutter();
    });

    testWidgets('Renders HomePage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ApodCubit>.value(
            value: apodCubit,
            child: HomePage(),
          ),
        ),
      );

      expect(find.text('Search APODS'), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
