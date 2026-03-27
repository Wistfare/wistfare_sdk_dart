import 'package:test/test.dart';
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
}
