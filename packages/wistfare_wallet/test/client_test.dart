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

Map<String, dynamic> _balanceJson() => {
      'wallet_id': 'wal_1',
      'available_balance': '45000',
      'pending_balance': '5000',
      'currency': 'RWF',
      'as_of': '2026-01-15T12:00:00Z',
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

Map<String, dynamic> _transactionEntryJson() => {
      'id': 'entry_1',
      'transaction_type': 'transfer',
      'from_wallet_id': 'wal_1',
      'to_wallet_id': 'wal_2',
      'amount': '10000',
      'fee': '100',
      'currency': 'RWF',
      'status': 'completed',
      'entry_hash': 'abc123',
      'description': 'Transfer',
      'created_at': '2026-01-01T00:00:00Z',
      'confirmed_at': '2026-01-01T00:01:00Z',
    };

Map<String, dynamic> _depositResultJson() => {
      'deposit_id': 'dep_1',
      'status': 'pending',
      'payment_url': 'https://pay.example.com/dep_1',
      'instructions': 'Dial *182#',
    };

Map<String, dynamic> _withdrawalResultJson() => {
      'withdrawal_id': 'wd_1',
      'status': 'processing',
      'estimated_arrival': '2026-01-01T01:00:00Z',
    };

Map<String, dynamic> _roleJson() => {
      'id': 'role_1',
      'wallet_id': 'wal_1',
      'name': 'Viewer',
      'permissions': ['view_balance'],
      'is_system': false,
      'created_by': 'usr_1',
      'created_at': '2026-01-01T00:00:00Z',
    };

Map<String, dynamic> _memberJson() => {
      'id': 'mem_1',
      'wallet_id': 'wal_1',
      'user_id': 'usr_2',
      'role_id': 'role_1',
      'role_name': 'Viewer',
      'permissions': ['view_balance'],
      'granted_by': 'usr_1',
      'created_at': '2026-01-01T00:00:00Z',
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
  late WalletClient client;

  setUp(() {
    mock = MockWistfare();
    client = WalletClient(mock);
  });

  group('WalletClient', () {
    // ── Wallets ──

    test('create posts to /v1/wallets', () async {
      mock.nextResponse = _walletJson();
      const params = CreateWalletParams(userId: 'usr_1', walletType: WalletType.personal);

      final result = await client.create(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/wallets');
      expect(mock.calls.first.body!['user_id'], 'usr_1');
      expect(result.id, 'wal_1');
    });

    test('get retrieves /v1/wallets/{id}', () async {
      mock.nextResponse = _walletJson();

      final result = await client.get('wal_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/wallets/wal_1');
      expect(result.id, 'wal_1');
    });

    test('getByOwner gets /v1/wallets/by-owner with user_id query', () async {
      mock.nextResponse = _walletJson();

      final result = await client.getByOwner('usr_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/wallets/by-owner');
      expect(mock.calls.first.query, {'user_id': 'usr_1'});
      expect(result.id, 'wal_1');
    });

    test('getBalance gets /v1/wallets/{id}/balance', () async {
      mock.nextResponse = _balanceJson();

      final result = await client.getBalance('wal_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/wallets/wal_1/balance');
      expect(result.availableBalance, '45000');
    });

    // ── Transfers ──

    test('transfer posts to /v1/wallets/transfers', () async {
      mock.nextResponse = _transferResultJson();
      const params = TransferParams(
        fromWalletId: 'wal_1',
        toWalletId: 'wal_2',
        amount: '10000',
        idempotencyKey: 'idem_1',
      );

      final result = await client.transfer(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/wallets/transfers');
      expect(mock.calls.first.body!['from_wallet_id'], 'wal_1');
      expect(result.transactionId, 'txn_1');
    });

    test('listTransactions gets /v1/wallets/{id}/transactions', () async {
      mock.nextResponse = _listJson([_transactionEntryJson()]);

      final result = await client.listTransactions('wal_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/wallets/wal_1/transactions');
      expect(result.data, hasLength(1));
    });

    test('listTransactions passes pagination params', () async {
      mock.nextResponse = _listJson([]);

      await client.listTransactions('wal_1', page: 2, perPage: 10);

      expect(mock.calls.first.query!['page'], '2');
      expect(mock.calls.first.query!['per_page'], '10');
    });

    // ── Deposits & Withdrawals ──

    test('initiateDeposit posts to /v1/wallets/deposits', () async {
      mock.nextResponse = _depositResultJson();
      const params = InitiateDepositParams(
        walletId: 'wal_1',
        amount: '5000',
        paymentMethod: 'mtn',
        phoneNumber: '+250781234567',
      );

      final result = await client.initiateDeposit(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/wallets/deposits');
      expect(result.depositId, 'dep_1');
    });

    test('initiateWithdrawal posts to /v1/wallets/withdrawals', () async {
      mock.nextResponse = _withdrawalResultJson();
      const params = InitiateWithdrawalParams(
        walletId: 'wal_1',
        amount: '5000',
        destinationType: 'mobile_money',
        destinationRef: '+250781234567',
      );

      final result = await client.initiateWithdrawal(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/wallets/withdrawals');
      expect(result.withdrawalId, 'wd_1');
    });

    // ── Wallet Roles ──

    test('createRole posts to /v1/wallets/roles', () async {
      mock.nextResponse = _roleJson();
      const params = CreateWalletRoleParams(
        walletId: 'wal_1',
        name: 'Viewer',
        permissions: ['view_balance'],
      );

      final result = await client.createRole(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/wallets/roles');
      expect(result.name, 'Viewer');
    });

    test('listRoles gets /v1/wallets/{id}/roles', () async {
      mock.nextResponse = _listJson([_roleJson()]);

      final result = await client.listRoles('wal_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/wallets/wal_1/roles');
      expect(result.data, hasLength(1));
    });

    test('updateRole patches /v1/wallets/roles/{id}', () async {
      mock.nextResponse = _roleJson();

      final result = await client.updateRole('role_1', name: 'Admin', permissions: ['all']);

      expect(mock.calls.first.method, 'PATCH');
      expect(mock.calls.first.path, '/v1/wallets/roles/role_1');
      expect(mock.calls.first.body!['name'], 'Admin');
      expect(mock.calls.first.body!['permissions'], ['all']);
      expect(result.id, 'role_1');
    });

    test('deleteRole deletes /v1/wallets/roles/{id}', () async {
      mock.nextResponse = null;

      await client.deleteRole('role_1');

      expect(mock.calls.first.method, 'DELETE');
      expect(mock.calls.first.path, '/v1/wallets/roles/role_1');
    });

    // ── Wallet Members ──

    test('addMember posts to /v1/wallets/members', () async {
      mock.nextResponse = _memberJson();
      const params = AddWalletMemberParams(
        walletId: 'wal_1',
        userId: 'usr_2',
        roleId: 'role_1',
      );

      final result = await client.addMember(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/wallets/members');
      expect(result.userId, 'usr_2');
    });

    test('listMembers gets /v1/wallets/{id}/members', () async {
      mock.nextResponse = _listJson([_memberJson()]);

      final result = await client.listMembers('wal_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/wallets/wal_1/members');
      expect(result.data, hasLength(1));
    });

    test('updateMemberRole patches /v1/wallets/members/{id}', () async {
      mock.nextResponse = _memberJson();

      final result = await client.updateMemberRole('mem_1', 'role_2');

      expect(mock.calls.first.method, 'PATCH');
      expect(mock.calls.first.path, '/v1/wallets/members/mem_1');
      expect(mock.calls.first.body, {'role_id': 'role_2'});
      expect(result.id, 'mem_1');
    });

    test('removeMember deletes /v1/wallets/members/{id}', () async {
      mock.nextResponse = null;

      await client.removeMember('mem_1');

      expect(mock.calls.first.method, 'DELETE');
      expect(mock.calls.first.path, '/v1/wallets/members/mem_1');
    });
  });
}
