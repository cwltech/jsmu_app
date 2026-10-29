import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatFullDate(DateTime date) {
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  static String formatBookingDate(DateTime date) {
    return DateFormat('EEE, dd MMM').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
}
