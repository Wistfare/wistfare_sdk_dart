import 'package:test/test.dart';
import 'package:wistfare_core/wistfare_core.dart';

void main() {
  group('ListResponse', () {
    test('fromJson parses all fields and maps items', () {
      final json = {
        'data': [
          {'value': 'a'},
          {'value': 'b'},
        ],
        'total': 10,
        'page': 1,
        'per_page': 2,
        'has_more': true,
      };

      final result = ListResponse.fromJson(
        json,
        (item) => item['value'] as String,
      );

      expect(result.data, ['a', 'b']);
      expect(result.total, 10);
      expect(result.page, 1);
      expect(result.perPage, 2);
      expect(result.hasMore, isTrue);
    });

    test('fromJson handles empty data list', () {
      final json = {
        'data': <Map<String, dynamic>>[],
        'total': 0,
        'page': 1,
        'per_page': 20,
        'has_more': false,
      };

      final result = ListResponse.fromJson(json, (item) => item);
      expect(result.data, isEmpty);
      expect(result.total, 0);
      expect(result.hasMore, isFalse);
    });
  });

  group('Address', () {
    test('fromJson parses all required fields', () {
      final json = {
        'city': 'Kigali',
        'street': '123 Main St',
        'district': 'Gasabo',
        'country': 'RW',
      };

      final address = Address.fromJson(json);
      expect(address.city, 'Kigali');
      expect(address.street, '123 Main St');
      expect(address.district, 'Gasabo');
      expect(address.country, 'RW');
      expect(address.latitude, isNull);
      expect(address.longitude, isNull);
    });

    test('fromJson parses optional lat/lng', () {
      final json = {
        'city': 'Kigali',
        'street': '123 Main St',
        'district': 'Gasabo',
        'country': 'RW',
        'latitude': -1.9403,
        'longitude': 29.8739,
      };

      final address = Address.fromJson(json);
      expect(address.latitude, -1.9403);
      expect(address.longitude, 29.8739);
    });

    test('fromJson handles integer lat/lng as num', () {
      final json = {
        'city': 'Kigali',
        'street': '123 Main St',
        'district': 'Gasabo',
        'country': 'RW',
        'latitude': 1,
        'longitude': 30,
      };

      final address = Address.fromJson(json);
      expect(address.latitude, 1.0);
      expect(address.longitude, 30.0);
    });

    test('toJson includes required fields', () {
      const address = Address(
        city: 'Kigali',
        street: '123 Main St',
        district: 'Gasabo',
        country: 'RW',
      );

      final json = address.toJson();
      expect(json, {
        'city': 'Kigali',
        'street': '123 Main St',
        'district': 'Gasabo',
        'country': 'RW',
      });
    });

    test('toJson includes optional lat/lng when present', () {
      const address = Address(
        city: 'Kigali',
        street: '123 Main St',
        district: 'Gasabo',
        country: 'RW',
        latitude: -1.94,
        longitude: 29.87,
      );

      final json = address.toJson();
      expect(json['latitude'], -1.94);
      expect(json['longitude'], 29.87);
    });

    test('toJson excludes null lat/lng', () {
      const address = Address(
        city: 'Kigali',
        street: '123 Main St',
        district: 'Gasabo',
        country: 'RW',
      );

      final json = address.toJson();
      expect(json.containsKey('latitude'), isFalse);
      expect(json.containsKey('longitude'), isFalse);
    });

    test('roundtrip fromJson/toJson preserves data', () {
      final original = {
        'city': 'Kigali',
        'street': '123 Main St',
        'district': 'Gasabo',
        'country': 'RW',
        'latitude': -1.94,
        'longitude': 29.87,
      };

      final address = Address.fromJson(original);
      final roundtripped = address.toJson();
      expect(roundtripped, original);
    });
  });

  group('ContactInfo', () {
    test('fromJson parses required fields', () {
      final json = {
        'phone': '+250781234567',
        'email': 'info@biz.rw',
      };

      final contact = ContactInfo.fromJson(json);
      expect(contact.phone, '+250781234567');
      expect(contact.email, 'info@biz.rw');
      expect(contact.website, isNull);
    });

    test('fromJson parses optional website', () {
      final json = {
        'phone': '+250781234567',
        'email': 'info@biz.rw',
        'website': 'https://biz.rw',
      };

      final contact = ContactInfo.fromJson(json);
      expect(contact.website, 'https://biz.rw');
    });

    test('toJson includes required fields', () {
      const contact = ContactInfo(phone: '+250781234567', email: 'info@biz.rw');
      final json = contact.toJson();
      expect(json, {'phone': '+250781234567', 'email': 'info@biz.rw'});
    });

    test('toJson includes website when present', () {
      const contact = ContactInfo(
        phone: '+250781234567',
        email: 'info@biz.rw',
        website: 'https://biz.rw',
      );

      final json = contact.toJson();
      expect(json['website'], 'https://biz.rw');
    });

    test('toJson excludes null website', () {
      const contact = ContactInfo(phone: '+250781234567', email: 'info@biz.rw');
      final json = contact.toJson();
      expect(json.containsKey('website'), isFalse);
    });

    test('roundtrip fromJson/toJson preserves data', () {
      final original = {
        'phone': '+250781234567',
        'email': 'info@biz.rw',
        'website': 'https://biz.rw',
      };

      final contact = ContactInfo.fromJson(original);
      expect(contact.toJson(), original);
    });
  });
}
