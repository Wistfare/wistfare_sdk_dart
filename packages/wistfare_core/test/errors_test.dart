import 'package:test/test.dart';
import 'package:wistfare_core/wistfare_core.dart';

void main() {
  group('WistfareException', () {
    test('stores message, statusCode, code', () {
      const e = WistfareException('Something failed', 500, 'internal_error');
      expect(e.message, 'Something failed');
      expect(e.statusCode, 500);
      expect(e.code, 'internal_error');
      expect(e.requestId, isNull);
    });

    test('stores optional requestId', () {
      const e = WistfareException('fail', 500, 'err', 'req_123');
      expect(e.requestId, 'req_123');
    });

    test('toString includes code, statusCode, message', () {
      const e = WistfareException('Something failed', 500, 'internal_error');
      expect(e.toString(), 'WistfareException(internal_error, 500): Something failed');
    });

    test('implements Exception', () {
      const e = WistfareException('fail', 500, 'err');
      expect(e, isA<Exception>());
    });
  });

  group('AuthenticationException', () {
    test('has correct defaults', () {
      const e = AuthenticationException();
      expect(e.message, 'Invalid or expired API key');
      expect(e.statusCode, 401);
      expect(e.code, 'authentication_error');
      expect(e.requestId, isNull);
    });

    test('accepts custom message and requestId', () {
      const e = AuthenticationException('Token expired', 'req_456');
      expect(e.message, 'Token expired');
      expect(e.requestId, 'req_456');
      expect(e.statusCode, 401);
      expect(e.code, 'authentication_error');
    });

    test('is a WistfareException', () {
      const e = AuthenticationException();
      expect(e, isA<WistfareException>());
    });
  });

  group('PermissionException', () {
    test('has correct defaults', () {
      const e = PermissionException();
      expect(e.message, 'Insufficient permissions');
      expect(e.statusCode, 403);
      expect(e.code, 'permission_error');
    });

    test('accepts custom message and requestId', () {
      const e = PermissionException('No access', 'req_789');
      expect(e.message, 'No access');
      expect(e.requestId, 'req_789');
    });
  });

  group('NotFoundException', () {
    test('has correct defaults', () {
      const e = NotFoundException();
      expect(e.message, 'Resource not found');
      expect(e.statusCode, 404);
      expect(e.code, 'not_found');
    });

    test('accepts custom message and requestId', () {
      const e = NotFoundException('Wallet not found', 'req_abc');
      expect(e.message, 'Wallet not found');
      expect(e.requestId, 'req_abc');
    });
  });

  group('ValidationException', () {
    test('has correct defaults', () {
      const e = ValidationException('Invalid input');
      expect(e.message, 'Invalid input');
      expect(e.statusCode, 400);
      expect(e.code, 'validation_error');
      expect(e.errors, isEmpty);
    });

    test('accepts errors map and requestId', () {
      const e = ValidationException(
        'Validation failed',
        errors: {
          'name': ['is required'],
          'email': ['is invalid'],
        },
        requestId: 'req_val',
      );
      expect(e.errors, hasLength(2));
      expect(e.errors['name'], ['is required']);
      expect(e.errors['email'], ['is invalid']);
      expect(e.requestId, 'req_val');
    });

    test('is a WistfareException', () {
      const e = ValidationException('bad');
      expect(e, isA<WistfareException>());
    });
  });

  group('RateLimitException', () {
    test('stores retryAfter and formats message', () {
      final e = RateLimitException(30);
      expect(e.retryAfter, 30);
      expect(e.statusCode, 429);
      expect(e.code, 'rate_limit');
      expect(e.message, 'Rate limit exceeded. Retry after 30s');
    });

    test('accepts requestId', () {
      final e = RateLimitException(5, 'req_rl');
      expect(e.requestId, 'req_rl');
      expect(e.retryAfter, 5);
    });

    test('is a WistfareException', () {
      final e = RateLimitException(1);
      expect(e, isA<WistfareException>());
    });
  });
}
