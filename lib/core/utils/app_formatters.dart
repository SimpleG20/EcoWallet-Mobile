import 'package:intl/intl.dart';

class AppFormatters {
  static String formatCurrency(double value, String locale) {
    final format = NumberFormat.simpleCurrency(locale: locale);
    return format.format(value);
  }

  static String formatDateShort(DateTime date, String locale) {
    return DateFormat.Md(locale).format(date);
  }
}
