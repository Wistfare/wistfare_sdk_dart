import 'package:test/test.dart';
import 'package:wistfare_core/wistfare_core.dart' show Address, ContactInfo;
import 'package:wistfare_business/wistfare_business.dart';

void main() {
  group('BusinessStatus', () {
    test('fromString parses all values', () {
      expect(BusinessStatus.fromString('active'), BusinessStatus.active);
      expect(BusinessStatus.fromString('pending'), BusinessStatus.pending);
      expect(BusinessStatus.fromString('suspended'), BusinessStatus.suspended);
      expect(BusinessStatus.fromString('closed'), BusinessStatus.closed);
    });

    test('fromString throws on unknown value', () {
      expect(() => BusinessStatus.fromString('unknown'), throwsArgumentError);
    });
  });

  group('InvitationStatus', () {
    test('fromString parses all values', () {
      expect(InvitationStatus.fromString('pending'), InvitationStatus.pending);
      expect(InvitationStatus.fromString('accepted'), InvitationStatus.accepted);
      expect(InvitationStatus.fromString('expired'), InvitationStatus.expired);
      expect(InvitationStatus.fromString('revoked'), InvitationStatus.revoked);
    });

    test('fromString throws on unknown value', () {
      expect(() => InvitationStatus.fromString('unknown'), throwsArgumentError);
    });
  });

  group('Business', () {
    test('fromJson parses all fields', () {
      final json = {
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

      final biz = Business.fromJson(json);
      expect(biz.id, 'biz_1');
      expect(biz.ownerId, 'usr_1');
      expect(biz.name, 'Test Cafe');
      expect(biz.slug, 'test-cafe');
      expect(biz.description, 'A cozy cafe');
      expect(biz.businessType, 'restaurant');
      expect(biz.category, 'food_beverage');
      expect(biz.logoUrl, 'https://img.example.com/logo.png');
      expect(biz.coverImageUrl, 'https://img.example.com/cover.png');
      expect(biz.address.city, 'Kigali');
      expect(biz.contact.phone, '+250781234567');
      expect(biz.walletId, 'wal_1');
      expect(biz.isVerified, isTrue);
      expect(biz.status, BusinessStatus.active);
      expect(biz.rating, 4.5);
      expect(biz.reviewCount, 120);
      expect(biz.createdAt, '2026-01-01T00:00:00Z');
      expect(biz.updatedAt, '2026-01-15T00:00:00Z');
    });

    test('fromJson handles integer rating as num', () {
      final json = {
        'id': 'biz_1',
        'owner_id': 'usr_1',
        'name': 'Test',
        'slug': 'test',
        'description': '',
        'business_type': 'retail',
        'category': 'other',
        'logo_url': '',
        'cover_image_url': '',
        'address': {
          'city': 'Kigali',
          'street': 'St',
          'district': 'D',
          'country': 'RW',
        },
        'contact': {
          'phone': '+250781234567',
          'email': 'a@b.com',
        },
        'wallet_id': 'wal_1',
        'is_verified': false,
        'status': 'pending',
        'rating': 5,
        'review_count': 0,
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
      };

      final biz = Business.fromJson(json);
      expect(biz.rating, 5.0);
    });
  });

  group('StaffMember', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'staff_1',
        'user_id': 'usr_2',
        'business_id': 'biz_1',
        'role': 'cashier',
        'department': 'operations',
        'is_active': true,
        'joined_at': '2026-01-05T00:00:00Z',
      };

      final staff = StaffMember.fromJson(json);
      expect(staff.id, 'staff_1');
      expect(staff.userId, 'usr_2');
      expect(staff.businessId, 'biz_1');
      expect(staff.role, 'cashier');
      expect(staff.department, 'operations');
      expect(staff.isActive, isTrue);
      expect(staff.joinedAt, '2026-01-05T00:00:00Z');
    });
  });

  group('Invitation', () {
    test('fromJson parses all fields', () {
      final json = {
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

      final inv = Invitation.fromJson(json);
      expect(inv.id, 'inv_1');
      expect(inv.businessId, 'biz_1');
      expect(inv.email, 'new@staff.rw');
      expect(inv.phone, '+250781234567');
      expect(inv.role, 'manager');
      expect(inv.invitedBy, 'usr_1');
      expect(inv.token, 'tok_abc123');
      expect(inv.status, InvitationStatus.pending);
      expect(inv.expiresAt, '2026-02-01T00:00:00Z');
      expect(inv.acceptedAt, '');
      expect(inv.createdAt, '2026-01-01T00:00:00Z');
    });
  });

  group('Team', () {
    test('fromJson parses all fields', () {
      final json = {
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

      final team = Team.fromJson(json);
      expect(team.id, 'team_1');
      expect(team.businessId, 'biz_1');
      expect(team.name, 'Engineering');
      expect(team.description, 'Dev team');
      expect(team.leadUserId, 'usr_1');
      expect(team.roleId, 'role_1');
      expect(team.isActive, isTrue);
      expect(team.memberCount, 5);
      expect(team.createdAt, '2026-01-01T00:00:00Z');
      expect(team.updatedAt, '2026-01-10T00:00:00Z');
    });
  });

  group('TeamMember', () {
    test('fromJson parses all fields', () {
      final json = {
        'team_id': 'team_1',
        'user_id': 'usr_2',
        'role': 'member',
        'joined_at': '2026-01-05T00:00:00Z',
      };

      final tm = TeamMember.fromJson(json);
      expect(tm.teamId, 'team_1');
      expect(tm.userId, 'usr_2');
      expect(tm.role, 'member');
      expect(tm.joinedAt, '2026-01-05T00:00:00Z');
    });
  });

  group('APIKeyInfo', () {
    test('fromJson parses all fields', () {
      final json = {
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

      final info = APIKeyInfo.fromJson(json);
      expect(info.id, 'ak_1');
      expect(info.businessId, 'biz_1');
      expect(info.name, 'Production Key');
      expect(info.environment, 'live');
      expect(info.prefix, 'wf_live_');
      expect(info.lastFour, '7890');
      expect(info.isActive, isTrue);
      expect(info.createdAt, '2026-01-01T00:00:00Z');
      expect(info.lastUsedAt, '2026-01-15T12:00:00Z');
    });
  });

  group('CreateAPIKeyResult', () {
    test('fromJson parses key and rawKey', () {
      final json = {
        'key': {
          'id': 'ak_1',
          'business_id': 'biz_1',
          'name': 'Test Key',
          'environment': 'test',
          'prefix': 'wf_test_',
          'last_four': '1234',
          'is_active': true,
          'created_at': '2026-01-01T00:00:00Z',
          'last_used_at': '',
        },
        'raw_key': 'wf_test_full_key_here1234',
      };

      final result = CreateAPIKeyResult.fromJson(json);
      expect(result.key.id, 'ak_1');
      expect(result.key.name, 'Test Key');
      expect(result.rawKey, 'wf_test_full_key_here1234');
    });
  });

  group('CreateBusinessParams', () {
    test('toJson includes required fields', () {
      const params = CreateBusinessParams(name: 'My Biz', businessType: 'restaurant');
      final json = params.toJson();
      expect(json['name'], 'My Biz');
      expect(json['business_type'], 'restaurant');
      expect(json.containsKey('description'), isFalse);
      expect(json.containsKey('address'), isFalse);
    });

    test('toJson includes optional fields when set', () {
      const params = CreateBusinessParams(
        name: 'My Biz',
        businessType: 'restaurant',
        description: 'A great place',
        category: 'food',
        address: Address(city: 'Kigali', street: 'St', district: 'D', country: 'RW'),
        contact: ContactInfo(phone: '+250781234567', email: 'a@b.com'),
      );
      final json = params.toJson();
      expect(json['description'], 'A great place');
      expect(json['category'], 'food');
      expect(json['address'], isA<Map>());
      expect(json['contact'], isA<Map>());
    });
  });

  group('UpdateBusinessParams', () {
    test('toJson only includes set fields', () {
      const params = UpdateBusinessParams(name: 'New Name');
      final json = params.toJson();
      expect(json, {'name': 'New Name'});
    });

    test('toJson includes all optional fields when set', () {
      const params = UpdateBusinessParams(
        name: 'New Name',
        description: 'Updated',
        category: 'retail',
        logoUrl: 'https://img.example.com/new.png',
        coverImageUrl: 'https://img.example.com/cover.png',
        address: Address(city: 'Kigali', street: 'St', district: 'D', country: 'RW'),
        contact: ContactInfo(phone: '+250781234567', email: 'a@b.com'),
      );
      final json = params.toJson();
      expect(json.length, 7);
    });
  });

  group('AssignStaffParams', () {
    test('toJson includes required fields', () {
      const params = AssignStaffParams(businessId: 'biz_1', userId: 'usr_1', role: 'cashier');
      final json = params.toJson();
      expect(json['business_id'], 'biz_1');
      expect(json['user_id'], 'usr_1');
      expect(json['role'], 'cashier');
      expect(json.containsKey('department'), isFalse);
    });

    test('toJson includes department when set', () {
      const params = AssignStaffParams(
        businessId: 'biz_1',
        userId: 'usr_1',
        role: 'cashier',
        department: 'sales',
      );
      expect(params.toJson()['department'], 'sales');
    });
  });

  group('InviteStaffParams', () {
    test('toJson includes required fields', () {
      const params = InviteStaffParams(businessId: 'biz_1', role: 'manager');
      final json = params.toJson();
      expect(json['business_id'], 'biz_1');
      expect(json['role'], 'manager');
      expect(json.containsKey('email'), isFalse);
      expect(json.containsKey('phone'), isFalse);
    });

    test('toJson includes email and phone when set', () {
      const params = InviteStaffParams(
        businessId: 'biz_1',
        role: 'manager',
        email: 'new@staff.rw',
        phone: '+250781234567',
      );
      final json = params.toJson();
      expect(json['email'], 'new@staff.rw');
      expect(json['phone'], '+250781234567');
    });
  });

  group('CreateTeamParams', () {
    test('toJson includes required fields', () {
      const params = CreateTeamParams(businessId: 'biz_1', name: 'Engineering');
      final json = params.toJson();
      expect(json['business_id'], 'biz_1');
      expect(json['name'], 'Engineering');
      expect(json.containsKey('description'), isFalse);
    });

    test('toJson includes optional fields when set', () {
      const params = CreateTeamParams(
        businessId: 'biz_1',
        name: 'Engineering',
        description: 'Dev team',
        leadUserId: 'usr_1',
        roleId: 'role_1',
      );
      final json = params.toJson();
      expect(json['description'], 'Dev team');
      expect(json['lead_user_id'], 'usr_1');
      expect(json['role_id'], 'role_1');
    });
  });

  group('CreateAPIKeyParams', () {
    test('toJson includes all fields', () {
      const params = CreateAPIKeyParams(
        businessId: 'biz_1',
        name: 'Test Key',
        environment: 'test',
      );
      final json = params.toJson();
      expect(json['business_id'], 'biz_1');
      expect(json['name'], 'Test Key');
      expect(json['environment'], 'test');
    });
  });
}
