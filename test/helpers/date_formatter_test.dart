import 'package:apod/helpers/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  group('BrazilianDateFormat', () {
    setUpAll(() async {
      await initializeDateFormatting('pt_BR', null);
    });

    test('format returns the date in the correct format', () {
      final brazilianDateFormat = BrazilianDateFormat();
      final date = DateTime(2022, 1, 1);
      final result = brazilianDateFormat.format(date);

      expect(result, '01/01/2022');
    });
  });
}
