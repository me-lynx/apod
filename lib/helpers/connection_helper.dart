import 'package:http/http.dart' as http;

class ConnectionHelper {
  ConnectionHelper();

  Future<bool> checkConnection() async {
    try {
      final result = await http.get(Uri.parse('https://www.google.com'));
      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }
}
