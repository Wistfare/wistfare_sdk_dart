/// Base error for all Wistfare SDK errors.
class WistfareException implements Exception {
  final String message;
  final int statusCode;
  final String code;
  final String? requestId;

  const WistfareException(this.message, this.statusCode, this.code, [this.requestId]);

  @override
  String toString() => 'WistfareException($code, $statusCode): $message';
}

class AuthenticationException extends WistfareException {
  const AuthenticationException([String message = 'Invalid or expired API key', String? requestId])
      : super(message, 401, 'authentication_error', requestId);
}

class PermissionException extends WistfareException {
  const PermissionException([String message = 'Insufficient permissions', String? requestId])
      : super(message, 403, 'permission_error', requestId);
}

class NotFoundException extends WistfareException {
  const NotFoundException([String message = 'Resource not found', String? requestId])
      : super(message, 404, 'not_found', requestId);
}

class ValidationException extends WistfareException {
  final Map<String, List<String>> errors;

  const ValidationException(String message, {this.errors = const {}, String? requestId})
      : super(message, 400, 'validation_error', requestId);
}

class RateLimitException extends WistfareException {
  final int retryAfter;

  RateLimitException(this.retryAfter, [String? requestId])
      : super('Rate limit exceeded. Retry after ${retryAfter}s', 429, 'rate_limit', requestId);
}
