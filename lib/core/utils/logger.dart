import 'dart:developer' as developer;

/// Simple logging utility
class AppLogger {
  static const String _defaultTag = 'AppLogger';

  /// Log debug message
  static void debug(String message, {String? tag, DateTime? timestamp}) {
    _log('DEBUG', message, tag: tag, timestamp: timestamp);
  }

  /// Log info message
  static void info(String message, {String? tag, DateTime? timestamp}) {
    _log('INFO', message, tag: tag, timestamp: timestamp);
  }

  /// Log warning message
  static void warning(String message, {String? tag, DateTime? timestamp}) {
    _log('WARNING', message, tag: tag, timestamp: timestamp);
  }

  /// Log error message
  static void error(
    String message, {
    String? tag,
    DateTime? timestamp,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', message, tag: tag, timestamp: timestamp);
    if (error != null) {
      developer.log('Error details: $error', name: tag ?? _defaultTag, level: 1000, error: error, stackTrace: stackTrace);
    }
  }

  static void _log(String level, String message, {String? tag, DateTime? timestamp}) {
    final time = timestamp ?? DateTime.now();
    final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
    final logTag = tag ?? _defaultTag;
    developer.log('[$formattedTime] [$level] $message', name: logTag);
  }

  /// Log exception with stack trace
  static void exception(
    dynamic exception,
    String message, {
    String? tag,
    StackTrace? stackTrace,
  }) {
    error(
      message,
      tag: tag,
      error: exception,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }
}

/// Usage examples:
/// AppLogger.debug('User logged in');
/// AppLogger.info('API request successful');
/// AppLogger.warning('Cache miss for key: user_preferences');
/// AppLogger.error('Failed to save data', error: e, stackTrace: stackTrace);
/// AppLogger.exception(e, 'Database operation failed');
