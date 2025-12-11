import 'package:intl/intl.dart';
import 'package:ecowallet/core/constants/app_constants.dart';

/// Utility class for date formatting
class DateFormatter {
  DateFormatter._();

  /// Format DateTime to display format (e.g., "Jan 15, 2024")
  static String toDisplayFormat(DateTime date) =>
      DateFormat(AppConstants.displayDateFormat).format(date);

  /// Format DateTime to ISO format (e.g., "2024-01-15")
  static String toIsoFormat(DateTime date) =>
      DateFormat(AppConstants.dateFormat).format(date);

  /// Format DateTime to full format with time
  static String toFullFormat(DateTime date) =>
      DateFormat(AppConstants.dateTimeFormat).format(date);

  /// Parse ISO format string to DateTime
  static DateTime fromIsoFormat(String dateString) =>
      DateFormat(AppConstants.dateFormat).parse(dateString);

  /// Get relative time string (e.g., "Today", "Yesterday", "2 days ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else {
      return toDisplayFormat(date);
    }
  }

  /// Get month name from date
  static String getMonthName(DateTime date) => DateFormat('MMMM').format(date);

  /// Get short month name from date
  static String getShortMonthName(DateTime date) =>
      DateFormat('MMM').format(date);
}
