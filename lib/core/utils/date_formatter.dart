import 'package:intl/intl.dart';

/// Utility class for date formatting
class DateFormatter {
  /// Format date to readable string (e.g., "Jan 15, 2024")
  static String toReadableDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format date to short string (e.g., "01/15/2024")
  static String toShortDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  /// Format date to time string (e.g., "2:30 PM")
  static String toTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Format date to date and time string (e.g., "Jan 15, 2024 2:30 PM")
  static String toDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy h:mm a').format(date);
  }

  /// Format date to ISO8601 string
  static String toIso8601(DateTime date) {
    return date.toIso8601String();
  }

  /// Parse date from ISO8601 string
  static DateTime? fromIso8601(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get relative time string (e.g., "2 hours ago", "in 3 days")
  static String toRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    return date.isAfter(firstDayOfWeek.subtract(const Duration(days: 1))) && date.isBefore(lastDayOfWeek.add(const Duration(days: 1)));
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Get end of week
  static DateTime endOfWeek(DateTime date) {
    return startOfWeek(date).add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    final nextMonth = date.month < 12 ? DateTime(date.year, date.month + 1, 1) : DateTime(date.year + 1, 1, 1);
    return nextMonth.subtract(const Duration(microseconds: 1));
  }
}
