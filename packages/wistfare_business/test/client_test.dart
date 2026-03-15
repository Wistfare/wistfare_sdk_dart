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

Map<String, dynamic> _staffJson() => {
      'id': 'staff_1',
      'user_id': 'usr_2',
      'business_id': 'biz_1',
      'role': 'cashier',
      'department': 'operations',
      'is_active': true,
      'joined_at': '2026-01-05T00:00:00Z',
    };

Map<String, dynamic> _invitationJson() => {
      'id': 'inv_1',
      'business_id': 'biz_1',
      'email': 'new@staff.rw',
      'phone': '+250781234567',
      'role': 'manager',
      'invited_by': 'usr_1',
      'token': 'tok_abc123',
      'status': 'pending',
      'expires_at': '2026-02-01T00:00:00Z',
      'accepted_at': '',
      'created_at': '2026-01-01T00:00:00Z',
    };

Map<String, dynamic> _teamJson() => {
      'id': 'team_1',
      'business_id': 'biz_1',
      'name': 'Engineering',
      'description': 'Dev team',
      'lead_user_id': 'usr_1',
      'role_id': 'role_1',
      'is_active': true,
      'member_count': 5,
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-10T00:00:00Z',
    };

Map<String, dynamic> _teamMemberJson() => {
      'team_id': 'team_1',
      'user_id': 'usr_2',
      'role': 'member',
      'joined_at': '2026-01-05T00:00:00Z',
    };

Map<String, dynamic> _apiKeyInfoJson() => {
      'id': 'ak_1',
      'business_id': 'biz_1',
      'name': 'Production Key',
      'environment': 'live',
      'prefix': 'wf_live_',
      'last_four': '7890',
      'is_active': true,
      'created_at': '2026-01-01T00:00:00Z',
      'last_used_at': '2026-01-15T12:00:00Z',
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
    // ── Businesses ──

    test('create posts to /v1/businesses', () async {
      mock.nextResponse = _businessJson();
      const params = CreateBusinessParams(name: 'Test Cafe', businessType: 'restaurant');

      final result = await client.create(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/businesses');
      expect(mock.calls.first.body!['name'], 'Test Cafe');
      expect(result.id, 'biz_1');
    });

    test('get retrieves /v1/businesses/{id}', () async {
      mock.nextResponse = _businessJson();

      final result = await client.get('biz_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/businesses/biz_1');
      expect(result.name, 'Test Cafe');
    });

    test('listMine gets /v1/businesses/mine', () async {
      mock.nextResponse = _listJson([_businessJson()]);

      final result = await client.listMine();

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/businesses/mine');
      expect(result.data, hasLength(1));
    });

    test('listMine passes pagination params', () async {
      mock.nextResponse = _listJson([]);

      await client.listMine(page: 2, perPage: 5);

      expect(mock.calls.first.query!['page'], '2');
      expect(mock.calls.first.query!['per_page'], '5');
    });

    test('update patches /v1/businesses/{id}', () async {
      mock.nextResponse = _businessJson();
      const params = UpdateBusinessParams(name: 'New Name');

      final result = await client.update('biz_1', params);

      expect(mock.calls.first.method, 'PATCH');
      expect(mock.calls.first.path, '/v1/businesses/biz_1');
      expect(mock.calls.first.body!['name'], 'New Name');
      expect(result.id, 'biz_1');
    });

    // ── Staff ──

    test('assignStaff posts to /v1/staff', () async {
      mock.nextResponse = _staffJson();
      const params = AssignStaffParams(businessId: 'biz_1', userId: 'usr_2', role: 'cashier');

      final result = await client.assignStaff(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/staff');
      expect(mock.calls.first.body!['business_id'], 'biz_1');
      expect(result.id, 'staff_1');
    });

    test('listStaff gets /v1/staff with business_id', () async {
      mock.nextResponse = _listJson([_staffJson()]);

      final result = await client.listStaff('biz_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/staff');
      expect(mock.calls.first.query!['business_id'], 'biz_1');
      expect(result.data, hasLength(1));
    });

    test('listStaff passes pagination params', () async {
      mock.nextResponse = _listJson([]);

      await client.listStaff('biz_1', page: 1, perPage: 10);

      expect(mock.calls.first.query!['page'], '1');
      expect(mock.calls.first.query!['per_page'], '10');
    });

    test('updateStaffRole patches /v1/staff/{id}/role', () async {
      mock.nextResponse = null;

      await client.updateStaffRole('staff_1', 'manager');

      expect(mock.calls.first.method, 'PATCH');
      expect(mock.calls.first.path, '/v1/staff/staff_1/role');
      expect(mock.calls.first.body, {'role': 'manager'});
    });

    test('removeStaff deletes /v1/staff/{id}', () async {
      mock.nextResponse = null;

      await client.removeStaff('staff_1');

      expect(mock.calls.first.method, 'DELETE');
      expect(mock.calls.first.path, '/v1/staff/staff_1');
    });

    // ── Invitations ──

    test('inviteStaff posts to /v1/invitations', () async {
      mock.nextResponse = _invitationJson();
      const params = InviteStaffParams(businessId: 'biz_1', role: 'manager', email: 'new@staff.rw');

      final result = await client.inviteStaff(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/invitations');
      expect(mock.calls.first.body!['business_id'], 'biz_1');
      expect(result.id, 'inv_1');
    });

    test('listInvitations gets /v1/invitations', () async {
      mock.nextResponse = _listJson([_invitationJson()]);

      final result = await client.listInvitations('biz_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/invitations');
      expect(mock.calls.first.query!['business_id'], 'biz_1');
      expect(result.data, hasLength(1));
    });

    test('acceptInvitation posts to /v1/invitations/accept', () async {
      mock.nextResponse = _staffJson();

      final result = await client.acceptInvitation('tok_abc123');

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/invitations/accept');
      expect(mock.calls.first.body, {'token': 'tok_abc123'});
      expect(result.id, 'staff_1');
    });

    test('revokeInvitation deletes /v1/invitations/{id}', () async {
      mock.nextResponse = null;

      await client.revokeInvitation('inv_1');

      expect(mock.calls.first.method, 'DELETE');
      expect(mock.calls.first.path, '/v1/invitations/inv_1');
    });

    // ── Teams ──

    test('createTeam posts to /v1/teams', () async {
      mock.nextResponse = _teamJson();
      const params = CreateTeamParams(businessId: 'biz_1', name: 'Engineering');

      final result = await client.createTeam(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/teams');
      expect(mock.calls.first.body!['name'], 'Engineering');
      expect(result.id, 'team_1');
    });

    test('listTeams gets /v1/teams', () async {
      mock.nextResponse = _listJson([_teamJson()]);

      final result = await client.listTeams('biz_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/teams');
      expect(mock.calls.first.query!['business_id'], 'biz_1');
      expect(result.data, hasLength(1));
    });

    test('updateTeam patches /v1/teams/{id}', () async {
      mock.nextResponse = _teamJson();

      final result = await client.updateTeam('team_1', name: 'Platform', description: 'Platform team');

      expect(mock.calls.first.method, 'PATCH');
      expect(mock.calls.first.path, '/v1/teams/team_1');
      expect(mock.calls.first.body!['name'], 'Platform');
      expect(mock.calls.first.body!['description'], 'Platform team');
      expect(result.id, 'team_1');
    });

    test('updateTeam passes leadUserId and roleId', () async {
      mock.nextResponse = _teamJson();

      await client.updateTeam('team_1', leadUserId: 'usr_3', roleId: 'role_2');

      expect(mock.calls.first.body!['lead_user_id'], 'usr_3');
      expect(mock.calls.first.body!['role_id'], 'role_2');
    });

    test('deleteTeam deletes /v1/teams/{id}', () async {
      mock.nextResponse = null;

      await client.deleteTeam('team_1');

      expect(mock.calls.first.method, 'DELETE');
      expect(mock.calls.first.path, '/v1/teams/team_1');
    });

    test('addTeamMember posts to /v1/teams/{id}/members', () async {
      mock.nextResponse = _teamMemberJson();

      final result = await client.addTeamMember('team_1', 'usr_2');

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/teams/team_1/members');
      expect(mock.calls.first.body!['user_id'], 'usr_2');
      expect(result.teamId, 'team_1');
    });

    test('addTeamMember passes optional role', () async {
      mock.nextResponse = _teamMemberJson();

      await client.addTeamMember('team_1', 'usr_2', role: 'lead');

      expect(mock.calls.first.body!['role'], 'lead');
    });

    test('removeTeamMember deletes /v1/teams/{teamId}/members/{userId}', () async {
      mock.nextResponse = null;

      await client.removeTeamMember('team_1', 'usr_2');

      expect(mock.calls.first.method, 'DELETE');
      expect(mock.calls.first.path, '/v1/teams/team_1/members/usr_2');
    });

    // ── API Keys ──

    test('createAPIKey posts to /v1/api-keys', () async {
      mock.nextResponse = {
        'key': _apiKeyInfoJson(),
        'raw_key': 'wf_live_full_key_7890',
      };
      const params = CreateAPIKeyParams(
        businessId: 'biz_1',
        name: 'Production Key',
        environment: 'live',
      );

      final result = await client.createAPIKey(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/api-keys');
      expect(mock.calls.first.body!['business_id'], 'biz_1');
      expect(result.key.id, 'ak_1');
      expect(result.rawKey, 'wf_live_full_key_7890');
    });

    test('listAPIKeys gets /v1/api-keys', () async {
      mock.nextResponse = _listJson([_apiKeyInfoJson()]);

      final result = await client.listAPIKeys('biz_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/api-keys');
      expect(mock.calls.first.query, {'business_id': 'biz_1'});
      expect(result.data, hasLength(1));
    });

    test('revokeAPIKey deletes /v1/api-keys/{id}', () async {
      mock.nextResponse = null;

      await client.revokeAPIKey('ak_1');

      expect(mock.calls.first.method, 'DELETE');
      expect(mock.calls.first.path, '/v1/api-keys/ak_1');
    });
  });
}
