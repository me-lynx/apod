import 'package:intl/intl.dart';

class BrazilianDateFormat {
  final DateFormat _dateFormat;

  BrazilianDateFormat() : _dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

  String format(DateTime datetime) {
    return _dateFormat.format(datetime);
  }
}
