/// Abstract base class for all failures
/// Failures represent business logic errors that can be handled gracefully
abstract class Failure {
  /// Human-readable error message
  final String message;

  /// Optional error code for programmatic handling
  final String? code;

  Failure(this.message, {this.code});

  @override
  String toString() => 'Failure: $message${code != null ? ' (code: $code)' : ''}';
}

/// Server-related failures (API errors, network issues, etc.)
class ServerFailure extends Failure {
  ServerFailure(super.message, {super.code});

  factory ServerFailure.networkError() {
    return ServerFailure('Network connection failed', code: 'NETWORK_ERROR');
  }

  factory ServerFailure.timeout() {
    return ServerFailure('Request timeout', code: 'TIMEOUT');
  }

  factory ServerFailure.unauthorized() {
    return ServerFailure('Unauthorized access', code: 'UNAUTHORIZED');
  }

  factory ServerFailure.notFound() {
    return ServerFailure('Resource not found', code: 'NOT_FOUND');
  }

  factory ServerFailure.serverError([String? message]) {
    return ServerFailure(message ?? 'Internal server error', code: 'SERVER_ERROR');
  }

  factory ServerFailure.unknown([String? message]) {
    return ServerFailure(message ?? 'Unknown server error', code: 'UNKNOWN');
  }
}

/// Local storage failures (database errors, file system issues, etc.)
class CacheFailure extends Failure {
  CacheFailure(super.message, {super.code});

  factory CacheFailure.readError() {
    return CacheFailure('Failed to read from local storage', code: 'READ_ERROR');
  }

  factory CacheFailure.writeError() {
    return CacheFailure('Failed to write to local storage', code: 'WRITE_ERROR');
  }

  factory CacheFailure.deleteError() {
    return CacheFailure('Failed to delete from local storage', code: 'DELETE_ERROR');
  }

  factory CacheFailure.databaseError([String? message]) {
    return CacheFailure(message ?? 'Database operation failed', code: 'DATABASE_ERROR');
  }

  factory CacheFailure.notFound() {
    return CacheFailure('Data not found in local storage', code: 'NOT_FOUND');
  }
}

/// Validation failures (invalid input, business rule violations, etc.)
class ValidationFailure extends Failure {
  ValidationFailure(super.message, {super.code});

  factory ValidationFailure.invalidInput([String? message]) {
    return ValidationFailure(message ?? 'Invalid input provided', code: 'INVALID_INPUT');
  }

  factory ValidationFailure.requiredField(String fieldName) {
    return ValidationFailure('$fieldName is required', code: 'REQUIRED_FIELD');
  }

  factory ValidationFailure.invalidFormat(String fieldName) {
    return ValidationFailure('$fieldName has invalid format', code: 'INVALID_FORMAT');
  }

  factory ValidationFailure.businessRule(String rule) {
    return ValidationFailure('Business rule violation: $rule', code: 'BUSINESS_RULE');
  }
}

/// Permission-related failures (missing permissions, denied access, etc.)
class PermissionFailure extends Failure {
  PermissionFailure(super.message, {super.code});

  factory PermissionFailure.storageDenied() {
    return PermissionFailure('Storage permission denied', code: 'STORAGE_DENIED');
  }

  factory PermissionFailure.locationDenied() {
    return PermissionFailure('Location permission denied', code: 'LOCATION_DENIED');
  }

  factory PermissionFailure.cameraDenied() {
    return PermissionFailure('Camera permission denied', code: 'CAMERA_DENIED');
  }

  factory PermissionFailure.unknown() {
    return PermissionFailure('Required permission not granted', code: 'PERMISSION_DENIED');
  }
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  UnknownFailure(super.message, {super.code});

  factory UnknownFailure.unexpected([String? message]) {
    return UnknownFailure(message ?? 'An unexpected error occurred', code: 'UNEXPECTED');
  }
}
