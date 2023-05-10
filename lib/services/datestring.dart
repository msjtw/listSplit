import 'package:intl/intl.dart';

String dateString(DateTime time) {
  return DateFormat('dd-MM-yyyy kk:mm').format(time);
}
