import 'package:intl/intl.dart';

getCurrrentDate() {
  DateTime now = DateTime.now();

  var formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  return formattedDate;
}
