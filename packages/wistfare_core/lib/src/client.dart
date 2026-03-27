import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'errors.dart';

const _defaultBaseUrl = 'https://api-production.wistfare.com';
const _defaultTimeout = Duration(seconds: 30);
const _sdkVersion = '0.1.0';

/// Core HTTP client shared by all Wistfare service packages.
class Wistfare {
  final String apiKey;
  final String baseUrl;
  final Duration timeout;
  final int maxRetries;
  final http.Client _http;

  Wistfare({
    required this.apiKey,
    String? baseUrl,
    this.timeout = _defaultTimeout,
    this.maxRetries = 2,
    http.Client? httpClient,
  })  : baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/+$'), ''),
        _http = httpClient ?? http.Client() {
    if (apiKey.isEmpty) {
      throw const WistfareException(
        'API key is required. Pass apiKey: "wf_live_..." or apiKey: "wf_test_...".',
        400,
        'missing_api_key',
      );
    }
  }

  /// True if using a test-mode API key.
  bool get isTestMode => apiKey.startsWith('wf_test_');

  /// Send an HTTP request to the Wistfare API.
  Future<Map<String, dynamic>?> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    Exception? lastError;
    var skipBackoff = false;

    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      if (attempt > 0 && !skipBackoff) {
        final delay = min(1000 * pow(2, attempt - 1).toInt(), 10000) + Random().nextInt(500);
        await Future.delayed(Duration(milliseconds: delay));
      }
      skipBackoff = false;

      try {
        final request = http.Request(method, uri);
        request.headers.addAll({
          'X-API-Key': apiKey,
          'User-Agent': 'wistfare-dart/$_sdkVersion',
          'Accept': 'application/json',
        });

        if (body != null) {
          request.headers['Content-Type'] = 'application/json';
          request.body = jsonEncode(body);
        }

        final streamed = await _http.send(request).timeout(timeout);
        final response = await http.Response.fromStream(streamed);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (response.statusCode == 204 || response.body.isEmpty) return null;
          return jsonDecode(response.body) as Map<String, dynamic>;
        }

        Map<String, dynamic>? errorBody;
        try {
          errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}

        final requestId = errorBody?['request_id'] as String? ??
            response.headers['x-request-id'];
        final message = (errorBody?['error'] as Map?)?['message'] as String? ??
            response.reasonPhrase ??
            'Unknown error';

        if (response.statusCode == 429) {
          final retryAfter = int.tryParse(response.headers['retry-after'] ?? '5') ?? 5;
          if (attempt < maxRetries) {
            await Future.delayed(Duration(seconds: retryAfter));
            skipBackoff = true;
            continue;
          }
          throw RateLimitException(retryAfter, requestId);
        }

        if (response.statusCode >= 500 && attempt < maxRetries) {
          lastError = WistfareException(message, response.statusCode, 'internal_error', requestId);
          continue;
        }

        throw _buildError(response.statusCode, message, errorBody, requestId);
      } on WistfareException {
        rethrow;
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        if (attempt >= maxRetries) break;
      }
    }

    throw lastError ?? const WistfareException('Request failed after retries', 500, 'internal_error');
  }

  /// Convenience methods.
  Future<Map<String, dynamic>?> get(String path, {Map<String, String>? query}) =>
      request('GET', path, query: query);

  Future<Map<String, dynamic>?> post(String path, {Map<String, dynamic>? body}) =>
      request('POST', path, body: body);

  Future<Map<String, dynamic>?> patch(String path, {Map<String, dynamic>? body}) =>
      request('PATCH', path, body: body);

  Future<Map<String, dynamic>?> delete(String path) => request('DELETE', path);

  /// Close the underlying HTTP client.
  void close() => _http.close();

  WistfareException _buildError(
    int status,
    String message,
    Map<String, dynamic>? body,
    String? requestId,
  ) {
    return switch (status) {
      401 => AuthenticationException(message, requestId),
      403 => PermissionException(message, requestId),
      404 => NotFoundException(message, requestId),
      400 || 422 => ValidationException(message, requestId: requestId),
      _ => WistfareException(message, status, (body?['error'] as Map?)?['code'] as String? ?? 'unknown', requestId),
    };
  }
}
