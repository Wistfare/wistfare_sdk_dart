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

/// Parameters for creating a business.
class CreateBusinessParams {
  final String name;
  final String? description;
  final String businessType;
  final String? category;
  final Address? address;
  final ContactInfo? contact;

  const CreateBusinessParams({
    required this.name,
    this.description,
    required this.businessType,
    this.category,
    this.address,
    this.contact,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        'business_type': businessType,
        if (category != null) 'category': category,
        if (address != null) 'address': address!.toJson(),
        if (contact != null) 'contact': contact!.toJson(),
      };
}

/// Parameters for updating a business.
class UpdateBusinessParams {
  final String? name;
  final String? description;
  final String? category;
  final String? logoUrl;
  final String? coverImageUrl;
  final Address? address;
  final ContactInfo? contact;

  const UpdateBusinessParams({
    this.name,
    this.description,
    this.category,
    this.logoUrl,
    this.coverImageUrl,
    this.address,
    this.contact,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (category != null) 'category': category,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (coverImageUrl != null) 'cover_image_url': coverImageUrl,
        if (address != null) 'address': address!.toJson(),
        if (contact != null) 'contact': contact!.toJson(),
      };
}

/// Staff member.
class StaffMember {
  final String id;
  final String userId;
  final String businessId;
  final String role;
  final String department;
  final bool isActive;
  final String joinedAt;

  const StaffMember({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.role,
    required this.department,
    required this.isActive,
    required this.joinedAt,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) => StaffMember(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        businessId: json['business_id'] as String,
        role: json['role'] as String,
        department: json['department'] as String,
        isActive: json['is_active'] as bool,
        joinedAt: json['joined_at'] as String,
      );
}

/// Parameters for assigning staff.
class AssignStaffParams {
  final String businessId;
  final String userId;
  final String role;
  final String? department;

  const AssignStaffParams({
    required this.businessId,
    required this.userId,
    required this.role,
    this.department,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'user_id': userId,
        'role': role,
        if (department != null) 'department': department,
      };
}

/// Staff invitation.
class Invitation {
  final String id;
  final String businessId;
  final String email;
  final String phone;
  final String role;
  final String invitedBy;
  final String token;
  final InvitationStatus status;
  final String expiresAt;
  final String acceptedAt;
  final String createdAt;

  const Invitation({
    required this.id,
    required this.businessId,
    required this.email,
    required this.phone,
    required this.role,
    required this.invitedBy,
    required this.token,
    required this.status,
    required this.expiresAt,
    required this.acceptedAt,
    required this.createdAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        id: json['id'] as String,
        businessId: json['business_id'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        role: json['role'] as String,
        invitedBy: json['invited_by'] as String,
        token: json['token'] as String,
        status: InvitationStatus.fromString(json['status'] as String),
        expiresAt: json['expires_at'] as String,
        acceptedAt: json['accepted_at'] as String,
        createdAt: json['created_at'] as String,
      );
}

enum InvitationStatus {
  pending,
  accepted,
  expired,
  revoked;

  static InvitationStatus fromString(String value) => switch (value) {
        'pending' => pending,
        'accepted' => accepted,
        'expired' => expired,
        'revoked' => revoked,
        _ => throw ArgumentError('Unknown InvitationStatus: $value'),
      };
}

/// Parameters for inviting staff.
class InviteStaffParams {
  final String businessId;
  final String? email;
  final String? phone;
  final String role;

  const InviteStaffParams({
    required this.businessId,
    this.email,
    this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        'role': role,
      };
}

/// Team.
class Team {
  final String id;
  final String businessId;
  final String name;
  final String description;
  final String leadUserId;
  final String roleId;
  final bool isActive;
  final int memberCount;
  final String createdAt;
  final String updatedAt;

  const Team({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.leadUserId,
    required this.roleId,
    required this.isActive,
    required this.memberCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json['id'] as String,
        businessId: json['business_id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        leadUserId: json['lead_user_id'] as String,
        roleId: json['role_id'] as String,
        isActive: json['is_active'] as bool,
        memberCount: json['member_count'] as int,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
      );
}

/// Parameters for creating a team.
class CreateTeamParams {
  final String businessId;
  final String name;
  final String? description;
  final String? leadUserId;
  final String? roleId;

  const CreateTeamParams({
    required this.businessId,
    required this.name,
    this.description,
    this.leadUserId,
    this.roleId,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'name': name,
        if (description != null) 'description': description,
        if (leadUserId != null) 'lead_user_id': leadUserId,
        if (roleId != null) 'role_id': roleId,
      };
}

/// Team member.
class TeamMember {
  final String teamId;
  final String userId;
  final String role;
  final String joinedAt;

  const TeamMember({
    required this.teamId,
    required this.userId,
    required this.role,
    required this.joinedAt,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        teamId: json['team_id'] as String,
        userId: json['user_id'] as String,
        role: json['role'] as String,
        joinedAt: json['joined_at'] as String,
      );
}

/// API key info (masked).
class APIKeyInfo {
  final String id;
  final String businessId;
  final String name;
  final String environment;
  final String prefix;
  final String lastFour;
  final bool isActive;
  final String createdAt;
  final String lastUsedAt;

  const APIKeyInfo({
    required this.id,
    required this.businessId,
    required this.name,
    required this.environment,
    required this.prefix,
    required this.lastFour,
    required this.isActive,
    required this.createdAt,
    required this.lastUsedAt,
  });

  factory APIKeyInfo.fromJson(Map<String, dynamic> json) => APIKeyInfo(
        id: json['id'] as String,
        businessId: json['business_id'] as String,
        name: json['name'] as String,
        environment: json['environment'] as String,
        prefix: json['prefix'] as String,
        lastFour: json['last_four'] as String,
        isActive: json['is_active'] as bool,
        createdAt: json['created_at'] as String,
        lastUsedAt: json['last_used_at'] as String,
      );
}

/// Parameters for creating an API key.
class CreateAPIKeyParams {
  final String businessId;
  final String name;
  final String environment;

  const CreateAPIKeyParams({
    required this.businessId,
    required this.name,
    required this.environment,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'name': name,
        'environment': environment,
      };
}

/// API key creation result (raw key only returned once).
class CreateAPIKeyResult {
  final APIKeyInfo key;
  final String rawKey;

  const CreateAPIKeyResult({required this.key, required this.rawKey});

  factory CreateAPIKeyResult.fromJson(Map<String, dynamic> json) => CreateAPIKeyResult(
        key: APIKeyInfo.fromJson(json['key'] as Map<String, dynamic>),
        rawKey: json['raw_key'] as String,
      );
}
