import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  static String getNowStr() {
    initializeDateFormatting('ja');
    DateTime now = DateTime.now();
    return DateFormat.yMMMMd('ja').add_jms().format(now);

  }
}
