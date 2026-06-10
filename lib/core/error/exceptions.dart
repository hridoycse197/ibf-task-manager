/// Abstract base class for all exceptions
/// Exceptions represent technical errors that occur during execution
abstract class AppException implements Exception {
  /// Human-readable error message
  final String message;

  /// Optional error code for programmatic handling
  final String? code;

  /// Original error that caused this exception
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType: $message');
    if (code != null) buffer.write(' (code: $code)');
    if (originalError != null) buffer.write(' | Original: $originalError');
    return buffer.toString();
  }
}

/// Network-related exceptions (connection issues, timeouts, etc.)
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalError});

  factory NetworkException.requestTimeout([dynamic error]) {
    return NetworkException('Request timeout', code: 'REQUEST_TIMEOUT', originalError: error);
  }

  factory NetworkException.noInternet([dynamic error]) {
    return NetworkException('No internet connection', code: 'NO_INTERNET', originalError: error);
  }

  factory NetworkException.connectionError([dynamic error]) {
    return NetworkException('Connection failed', code: 'CONNECTION_ERROR', originalError: error);
  }

  factory NetworkException.unknown([dynamic error]) {
    return NetworkException('Unknown network error', code: 'UNKNOWN_NETWORK', originalError: error);
  }
}

/// Server-related exceptions (API errors, HTTP status codes, etc.)
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode, super.code, super.originalError});

  factory ServerException.badRequest([dynamic error]) {
    return ServerException('Bad request', statusCode: 400, code: 'BAD_REQUEST', originalError: error);
  }

  factory ServerException.unauthorized([dynamic error]) {
    return ServerException('Unauthorized', statusCode: 401, code: 'UNAUTHORIZED', originalError: error);
  }

  factory ServerException.forbidden([dynamic error]) {
    return ServerException('Forbidden', statusCode: 403, code: 'FORBIDDEN', originalError: error);
  }

  factory ServerException.notFound([dynamic error]) {
    return ServerException('Resource not found', statusCode: 404, code: 'NOT_FOUND', originalError: error);
  }

  factory ServerException.methodNotAllowed([dynamic error]) {
    return ServerException('Method not allowed', statusCode: 405, code: 'METHOD_NOT_ALLOWED', originalError: error);
  }

  factory ServerException.internalServerError([dynamic error]) {
    return ServerException('Internal server error', statusCode: 500, code: 'INTERNAL_SERVER_ERROR', originalError: error);
  }

  factory ServerException.serviceUnavailable([dynamic error]) {
    return ServerException('Service unavailable', statusCode: 503, code: 'SERVICE_UNAVAILABLE', originalError: error);
  }

  factory ServerException.fromStatusCode(int statusCode, [dynamic error]) {
    return ServerException(
      'HTTP error: $statusCode',
      statusCode: statusCode,
      code: 'HTTP_ERROR_$statusCode',
      originalError: error,
    );
  }

  factory ServerException.unknown([dynamic error]) {
    return ServerException('Unknown server error', code: 'UNKNOWN_SERVER', originalError: error);
  }
}

/// Local storage exceptions (database errors, file system issues, etc.)
class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.originalError});

  factory CacheException.readError([dynamic error]) {
    return CacheException('Failed to read from cache', code: 'CACHE_READ_ERROR', originalError: error);
  }

  factory CacheException.writeError([dynamic error]) {
    return CacheException('Failed to write to cache', code: 'CACHE_WRITE_ERROR', originalError: error);
  }

  factory CacheException.deleteError([dynamic error]) {
    return CacheException('Failed to delete from cache', code: 'CACHE_DELETE_ERROR', originalError: error);
  }

  factory CacheException.databaseError([dynamic error]) {
    return CacheException('Database operation failed', code: 'DATABASE_ERROR', originalError: error);
  }

  factory CacheException.notFound([dynamic error]) {
    return CacheException('Data not found in cache', code: 'CACHE_NOT_FOUND', originalError: error);
  }

  factory CacheException.initializationError([dynamic error]) {
    return CacheException('Failed to initialize cache', code: 'CACHE_INIT_ERROR', originalError: error);
  }

  factory CacheException.unknown([dynamic error]) {
    return CacheException('Unknown cache error', code: 'UNKNOWN_CACHE', originalError: error);
  }
}

/// Serialization exceptions (JSON parsing, data transformation, etc.)
class SerializationException extends AppException {
  const SerializationException(super.message, {super.code, super.originalError});

  factory SerializationException.jsonParseError([dynamic error]) {
    return SerializationException('Failed to parse JSON', code: 'JSON_PARSE_ERROR', originalError: error);
  }

  factory SerializationException.invalidDataType([dynamic error]) {
    return SerializationException('Invalid data type', code: 'INVALID_DATA_TYPE', originalError: error);
  }

  factory SerializationException.missingField(String fieldName, [dynamic error]) {
    return SerializationException('Missing required field: $fieldName', code: 'MISSING_FIELD', originalError: error);
  }

  factory SerializationException.unknown([dynamic error]) {
    return SerializationException('Unknown serialization error', code: 'UNKNOWN_SERIALIZATION', originalError: error);
  }
}

/// Permission exceptions (missing permissions, denied access, etc.)
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code, super.originalError});

  factory PermissionException.storageDenied() {
    return const PermissionException('Storage permission denied', code: 'STORAGE_DENIED');
  }

  factory PermissionException.locationDenied() {
    return const PermissionException('Location permission denied', code: 'LOCATION_DENIED');
  }

  factory PermissionException.cameraDenied() {
    return const PermissionException('Camera permission denied', code: 'CAMERA_DENIED');
  }

  factory PermissionException.notificationDenied() {
    return const PermissionException('Notification permission denied', code: 'NOTIFICATION_DENIED');
  }

  factory PermissionException.unknown(String permission) {
    return PermissionException('$permission permission denied', code: 'PERMISSION_DENIED');
  }
}

/// Validation exceptions (invalid input, format errors, etc.)
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.originalError});

  factory ValidationException.invalidInput([String? message, dynamic error]) {
    return ValidationException(message ?? 'Invalid input provided', code: 'INVALID_INPUT', originalError: error);
  }

  factory ValidationException.requiredField(String fieldName, [dynamic error]) {
    return ValidationException('$fieldName is required', code: 'REQUIRED_FIELD', originalError: error);
  }

  factory ValidationException.invalidFormat(String fieldName, [dynamic error]) {
    return ValidationException('$fieldName has invalid format', code: 'INVALID_FORMAT', originalError: error);
  }

  factory ValidationException.outOfRange(String fieldName, [dynamic error]) {
    return ValidationException('$fieldName is out of range', code: 'OUT_OF_RANGE', originalError: error);
  }

  factory ValidationException.businessRule(String rule, [dynamic error]) {
    return ValidationException('Business rule violation: $rule', code: 'BUSINESS_RULE', originalError: error);
  }

  factory ValidationException.unknown([dynamic error]) {
    return ValidationException('Validation error', code: 'VALIDATION_ERROR', originalError: error);
  }
}
