import 'package:test/test.dart';
import 'package:wistfare_core/wistfare_core.dart';
import 'package:wistfare_wallet/wistfare_wallet.dart';

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

Map<String, dynamic> _walletJson() => {
      'id': 'wal_1',
      'user_id': 'usr_1',
      'wallet_type': 'personal',
      'kyc_tier': 'tier_1',
      'state': 'active',
      'balance': '50000',
      'currency': 'RWF',
      'azampay_linked': true,
      'created_at': '2026-01-01T00:00:00Z',
    };

Map<String, dynamic> _transferResultJson() => {
      'transaction_id': 'txn_1',
      'status': 'completed',
      'from_balance': '40000',
      'to_balance': '60000',
      'amount': '10000',
      'fee': '100',
      'currency': 'RWF',
      'created_at': '2026-01-01T00:00:00Z',
    };

void main() {
  late MockWistfare mock;
  late WalletClient client;

  setUp(() {
    mock = MockWistfare();
    client = WalletClient(mock);
  });

  group('WalletClient', () {
    test('get retrieves /v1/wallets with walletId query', () async {
      mock.nextResponse = _walletJson();

      final result = await client.get(walletId: 'wal_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/wallets');
      expect(mock.calls.first.query, {'wallet_id': 'wal_1'});
      expect(result.id, 'wal_1');
    });

    test('get retrieves /v1/wallets with ownerId query', () async {
      mock.nextResponse = _walletJson();

      final result = await client.get(ownerId: 'usr_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/wallets');
      expect(mock.calls.first.query, {'owner_id': 'usr_1'});
      expect(result.id, 'wal_1');
    });

    test('transfer posts to /v1/wallets/transfers', () async {
      mock.nextResponse = _transferResultJson();
      const params = TransferParams(
        fromWalletId: 'wal_1',
        toWalletId: 'wal_2',
        amount: '10000',
        referenceId: 'idem_1',
      );

      final result = await client.transfer(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/wallets/transfers');
      expect(mock.calls.first.body!['from_wallet_id'], 'wal_1');
      expect(result.transactionId, 'txn_1');
    });

    test('transfer includes optional description', () async {
      mock.nextResponse = _transferResultJson();
      const params = TransferParams(
        fromWalletId: 'wal_1',
        toWalletId: 'wal_2',
        amount: '10000',
        description: 'Rent',
        referenceId: 'idem_1',
      );

      await client.transfer(params);

      expect(mock.calls.first.body!['description'], 'Rent');
    });
  });
}
