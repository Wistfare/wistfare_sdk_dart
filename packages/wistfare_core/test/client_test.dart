import 'package:test/test.dart';
import 'package:wistfare_core/wistfare_core.dart';

void main() {
  group('Wistfare client', () {
    test('throws WistfareException when API key is empty', () {
      expect(
        () => Wistfare(apiKey: ''),
        throwsA(isA<WistfareException>()
            .having((e) => e.code, 'code', 'missing_api_key')
            .having((e) => e.statusCode, 'statusCode', 400)),
      );
    });

    test('accepts valid API key', () {
      final client = Wistfare(apiKey: 'wf_live_abc123');
      expect(client.apiKey, 'wf_live_abc123');
      client.close();
    });

    test('isTestMode returns true for test keys', () {
      final client = Wistfare(apiKey: 'wf_test_abc123');
      expect(client.isTestMode, isTrue);
      client.close();
    });

    test('isTestMode returns false for live keys', () {
      final client = Wistfare(apiKey: 'wf_live_abc123');
      expect(client.isTestMode, isFalse);
      client.close();
    });

    test('isTestMode returns false for arbitrary keys', () {
      final client = Wistfare(apiKey: 'some_random_key');
      expect(client.isTestMode, isFalse);
      client.close();
    });

    test('uses default base URL when none provided', () {
      final client = Wistfare(apiKey: 'wf_test_abc');
      expect(client.baseUrl, 'https://api-production.wistfare.com');
      client.close();
    });

    test('strips trailing slashes from base URL', () {
      final client = Wistfare(apiKey: 'wf_test_abc', baseUrl: 'https://api.example.com/');
      expect(client.baseUrl, 'https://api.example.com');
      client.close();
    });

    test('strips multiple trailing slashes from base URL', () {
      final client = Wistfare(apiKey: 'wf_test_abc', baseUrl: 'https://api.example.com///');
      expect(client.baseUrl, 'https://api.example.com');
      client.close();
    });

    test('preserves base URL without trailing slash', () {
      final client = Wistfare(apiKey: 'wf_test_abc', baseUrl: 'https://custom.api.com');
      expect(client.baseUrl, 'https://custom.api.com');
      client.close();
    });

    test('uses default timeout of 30 seconds', () {
      final client = Wistfare(apiKey: 'wf_test_abc');
      expect(client.timeout, const Duration(seconds: 30));
      client.close();
    });

    test('accepts custom timeout', () {
      final client = Wistfare(apiKey: 'wf_test_abc', timeout: const Duration(seconds: 60));
      expect(client.timeout, const Duration(seconds: 60));
      client.close();
    });

    test('uses default maxRetries of 2', () {
      final client = Wistfare(apiKey: 'wf_test_abc');
      expect(client.maxRetries, 2);
      client.close();
    });

    test('accepts custom maxRetries', () {
      final client = Wistfare(apiKey: 'wf_test_abc', maxRetries: 5);
      expect(client.maxRetries, 5);
      client.close();
    });
  });
}
