import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  String day = '0${date.day}'.substring(0, 2);
  String month = '0${date.month}'.substring(0, 2);
  return '$day/$month/${date.year}';
}

String formatDateFull(DateTime date) {
  return DateFormat('d MMM y').format(date);
}
