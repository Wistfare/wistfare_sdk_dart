import 'package:wistfare_core/wistfare_core.dart';

import 'types.dart';

/// Wistfare Business client — manage businesses, staff, teams & API keys.
class BusinessClient {
  final Wistfare _client;

  BusinessClient(this._client);

  // ── Businesses ──

  /// Create a new business.
  Future<Business> create(CreateBusinessParams params) async {
    final json = await _client.post('/v1/businesses', body: params.toJson());
    return Business.fromJson(json!);
  }

  /// Get a business by ID.
  Future<Business> get(String businessId) async {
    final json = await _client.get('/v1/businesses/$businessId');
    return Business.fromJson(json!);
  }

  /// List businesses owned by the current user.
  Future<ListResponse<Business>> listMine({int? page, int? perPage}) async {
    final json = await _client.get('/v1/businesses/mine', query: {
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, Business.fromJson);
  }

  /// Update a business.
  Future<Business> update(String businessId, UpdateBusinessParams params) async {
    final json = await _client.patch('/v1/businesses/$businessId', body: params.toJson());
    return Business.fromJson(json!);
  }

  // ── Staff ──

  /// Assign a user as staff to a business.
  Future<StaffMember> assignStaff(AssignStaffParams params) async {
    final json = await _client.post('/v1/staff', body: params.toJson());
    return StaffMember.fromJson(json!);
  }

  /// List staff members of a business.
  Future<ListResponse<StaffMember>> listStaff(String businessId, {int? page, int? perPage}) async {
    final json = await _client.get('/v1/staff', query: {
      'business_id': businessId,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, StaffMember.fromJson);
  }

  /// Update a staff member's role.
  Future<void> updateStaffRole(String staffId, String role) async {
    await _client.patch('/v1/staff/$staffId/role', body: {'role': role});
  }

  /// Remove a staff member.
  Future<void> removeStaff(String staffId) async {
    await _client.delete('/v1/staff/$staffId');
  }

  // ── Invitations ──

  /// Invite a user to join a business as staff.
  Future<Invitation> inviteStaff(InviteStaffParams params) async {
    final json = await _client.post('/v1/invitations', body: params.toJson());
    return Invitation.fromJson(json!);
  }

  /// List pending invitations for a business.
  Future<ListResponse<Invitation>> listInvitations(String businessId, {int? page, int? perPage}) async {
    final json = await _client.get('/v1/invitations', query: {
      'business_id': businessId,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, Invitation.fromJson);
  }

  /// Accept a staff invitation.
  Future<StaffMember> acceptInvitation(String token) async {
    final json = await _client.post('/v1/invitations/accept', body: {'token': token});
    return StaffMember.fromJson(json!);
  }

  /// Revoke a pending invitation.
  Future<void> revokeInvitation(String invitationId) async {
    await _client.delete('/v1/invitations/$invitationId');
  }

  // ── Teams ──

  /// Create a team within a business.
  Future<Team> createTeam(CreateTeamParams params) async {
    final json = await _client.post('/v1/teams', body: params.toJson());
    return Team.fromJson(json!);
  }

  /// List teams in a business.
  Future<ListResponse<Team>> listTeams(String businessId, {int? page, int? perPage}) async {
    final json = await _client.get('/v1/teams', query: {
      'business_id': businessId,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, Team.fromJson);
  }

  /// Update a team.
  Future<Team> updateTeam(String teamId, {String? name, String? description, String? leadUserId, String? roleId}) async {
    final json = await _client.patch('/v1/teams/$teamId', body: {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (leadUserId != null) 'lead_user_id': leadUserId,
      if (roleId != null) 'role_id': roleId,
    });
    return Team.fromJson(json!);
  }

  /// Delete a team.
  Future<void> deleteTeam(String teamId) async {
    await _client.delete('/v1/teams/$teamId');
  }

  /// Add a member to a team.
  Future<TeamMember> addTeamMember(String teamId, String userId, {String? role}) async {
    final json = await _client.post('/v1/teams/$teamId/members', body: {
      'user_id': userId,
      if (role != null) 'role': role,
    });
    return TeamMember.fromJson(json!);
  }

  /// Remove a member from a team.
  Future<void> removeTeamMember(String teamId, String userId) async {
    await _client.delete('/v1/teams/$teamId/members/$userId');
  }

  // ── API Keys ──

  /// Create an API key for a business. The raw key is only returned once.
  Future<CreateAPIKeyResult> createAPIKey(CreateAPIKeyParams params) async {
    final json = await _client.post('/v1/api-keys', body: params.toJson());
    return CreateAPIKeyResult.fromJson(json!);
  }

  /// List API keys for a business (keys are masked).
  Future<ListResponse<APIKeyInfo>> listAPIKeys(String businessId) async {
    final json = await _client.get('/v1/api-keys', query: {'business_id': businessId});
    return ListResponse.fromJson(json!, APIKeyInfo.fromJson);
  }

  /// Revoke an API key.
  Future<void> revokeAPIKey(String apiKeyId) async {
    await _client.delete('/v1/api-keys/$apiKeyId');
  }
}
