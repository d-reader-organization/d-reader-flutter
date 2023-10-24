import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  String day = '0${date.day}'.substring(0, 2);
  String month = '0${date.month}'.substring(0, 2);
  return '$day/$month/${date.year}';
}

String formatDateFull(DateTime date) {
  return DateFormat('d MMM y').format(date);
}

String formatDateInRelative(DateTime? date) {
  if (date == null) {
    return '';
  }
  final currentDate = DateTime.now();
  final difference = date.difference(currentDate);
  const hoursPerDay = 24;
  const minutesPerHour = 60;
  const secondsPerMinute = 60;

  if (difference.inDays > 0) {
    final hoursLeft = difference.inHours - hoursPerDay;
    return '${difference.inDays}d ${hoursLeft}h';
  } else if (difference.inHours > 0) {
    final minutesLeft =
        difference.inMinutes - (difference.inHours * minutesPerHour);
    return '${difference.inHours}h ${minutesLeft}m';
  } else if (difference.inMinutes > 0) {
    final secondsLeft =
        difference.inSeconds - (difference.inMinutes * secondsPerMinute);
    return '${difference.inMinutes}m ${secondsLeft}s';
  } else if (difference.inSeconds > 0) {
    return '${difference.inSeconds}s';
  }
  return '';
}
