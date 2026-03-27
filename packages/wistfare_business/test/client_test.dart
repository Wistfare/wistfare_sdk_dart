import 'package:test/test.dart';
import 'package:wistfare_core/wistfare_core.dart';
import 'package:wistfare_business/wistfare_business.dart';

class MockWistfare extends Wistfare {
  final List<({String method, String path, Map<String, dynamic>? body, Map<String, String>? query})> calls = [];
  Map<String, dynamic>? nextResponse;

  MockWistfare() : super(apiKey: 'wf_test_mock');

  @override
  Future<Map<String, dynamic>?> get(String path, {Map<String, String>? query}) async {
    calls.add((method: 'GET', path: path, body: null, query: query));
    return nextResponse;
  }

  @override
  Future<Map<String, dynamic>?> post(String path, {Map<String, dynamic>? body}) async {
    calls.add((method: 'POST', path: path, body: body, query: null));
    return nextResponse;
  }

  @override
  Future<Map<String, dynamic>?> patch(String path, {Map<String, dynamic>? body}) async {
    calls.add((method: 'PATCH', path: path, body: body, query: null));
    return nextResponse;
  }

  @override
  Future<Map<String, dynamic>?> delete(String path) async {
    calls.add((method: 'DELETE', path: path, body: null, query: null));
    return nextResponse;
  }
}

Map<String, dynamic> _businessJson() => {
      'id': 'biz_1',
      'owner_id': 'usr_1',
      'name': 'Test Cafe',
      'slug': 'test-cafe',
      'description': 'A cozy cafe',
      'business_type': 'restaurant',
      'category': 'food_beverage',
      'logo_url': 'https://img.example.com/logo.png',
      'cover_image_url': 'https://img.example.com/cover.png',
      'address': {
        'city': 'Kigali',
        'street': '123 Main St',
        'district': 'Gasabo',
        'country': 'RW',
      },
      'contact': {
        'phone': '+250781234567',
        'email': 'info@testcafe.rw',
      },
      'wallet_id': 'wal_1',
      'is_verified': true,
      'status': 'active',
      'rating': 4.5,
      'review_count': 120,
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-15T00:00:00Z',
    };

Map<String, dynamic> _listJson(List<Map<String, dynamic>> items) => {
      'data': items,
      'total': items.length,
      'page': 1,
      'per_page': 20,
      'has_more': false,
    };

void main() {
  late MockWistfare mock;
  late BusinessClient client;

  setUp(() {
    mock = MockWistfare();
    client = BusinessClient(mock);
  });

  group('BusinessClient', () {
    test('get retrieves /v1/businesses/{id}', () async {
      mock.nextResponse = _businessJson();

      final result = await client.get('biz_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/businesses/biz_1');
      expect(result.name, 'Test Cafe');
    });

    test('list gets /v1/businesses', () async {
      mock.nextResponse = _listJson([_businessJson()]);

      final result = await client.list();

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/businesses');
      expect(result.data, hasLength(1));
    });

    test('list passes businessId and pagination params', () async {
      mock.nextResponse = _listJson([]);

      await client.list(businessId: 'biz_123', page: 2, perPage: 5);

      expect(mock.calls.first.query!['business_id'], 'biz_123');
      expect(mock.calls.first.query!['page'], '2');
      expect(mock.calls.first.query!['per_page'], '5');
    });
  });
}
