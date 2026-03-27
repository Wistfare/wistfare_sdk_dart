import 'package:wistfare_core/wistfare_core.dart' show Address, ContactInfo;

/// Business resource.
class Business {
  final String id;
  final String ownerId;
  final String name;
  final String slug;
  final String description;
  final String businessType;
  final String category;
  final String logoUrl;
  final String coverImageUrl;
  final Address address;
  final ContactInfo contact;
  final String walletId;
  final bool isVerified;
  final BusinessStatus status;
  final double rating;
  final int reviewCount;
  final String createdAt;
  final String updatedAt;

  const Business({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.slug,
    required this.description,
    required this.businessType,
    required this.category,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.address,
    required this.contact,
    required this.walletId,
    required this.isVerified,
    required this.status,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json['id'] as String,
        ownerId: json['owner_id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
        description: json['description'] as String,
        businessType: json['business_type'] as String,
        category: json['category'] as String,
        logoUrl: json['logo_url'] as String,
        coverImageUrl: json['cover_image_url'] as String,
        address: Address.fromJson(json['address'] as Map<String, dynamic>),
        contact: ContactInfo.fromJson(json['contact'] as Map<String, dynamic>),
        walletId: json['wallet_id'] as String,
        isVerified: json['is_verified'] as bool,
        status: BusinessStatus.fromString(json['status'] as String),
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['review_count'] as int,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
      );
}

enum BusinessStatus {
  active,
  pending,
  suspended,
  closed;

  static BusinessStatus fromString(String value) => switch (value) {
        'active' => active,
        'pending' => pending,
        'suspended' => suspended,
        'closed' => closed,
        _ => throw ArgumentError('Unknown BusinessStatus: $value'),
      };
}
