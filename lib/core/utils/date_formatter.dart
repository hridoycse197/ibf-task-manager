import 'package:intl/intl.dart';

/// Utility class for date formatting
class DateFormatter {
  /// Format date to readable string (e.g., "Jan 15, 2024")
  static String toReadableDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
