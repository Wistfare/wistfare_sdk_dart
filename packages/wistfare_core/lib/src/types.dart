/// Standard paginated list response.
class ListResponse<T> {
  final List<T> data;
  final int total;
  final int page;
  final int perPage;
  final bool hasMore;

  const ListResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.perPage,
    required this.hasMore,
  });

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    return ListResponse(
      data: (json['data'] as List).map((e) => fromItem(e as Map<String, dynamic>)).toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      perPage: json['per_page'] as int,
      hasMore: json['has_more'] as bool,
    );
  }
}

/// Shared address type.
class Address {
  final String city;
  final String street;
  final String district;
  final String country;
  final double? latitude;
  final double? longitude;

  const Address({
    required this.city,
    required this.street,
    required this.district,
    required this.country,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json['city'] as String,
        street: json['street'] as String,
        district: json['district'] as String,
        country: json['country'] as String,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'city': city,
        'street': street,
        'district': district,
        'country': country,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };
}

/// Shared contact info type.
class ContactInfo {
  final String phone;
  final String email;
  final String? website;

  const ContactInfo({required this.phone, required this.email, this.website});

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
        phone: json['phone'] as String,
        email: json['email'] as String,
        website: json['website'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'email': email,
        if (website != null) 'website': website,
      };
}
