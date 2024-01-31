import 'package:apod/helpers/connection_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('ConnectionHelper', () {
    late ConnectionHelper connectionHelper;

    setUp(() {
      connectionHelper = ConnectionHelper();
    });

    test('checkConnection should return true when connected to Google',
        () async {
      bool isConnected = await connectionHelper.checkConnection();
      expect(isConnected, isTrue);
    });
  });
}
