import 'package:wistfare_core/wistfare_core.dart';

import 'types.dart';

/// Wistfare Wallet client — balances, transfers, deposits & withdrawals.
class WalletClient {
  final Wistfare _client;

  WalletClient(this._client);

  // ── Wallets ──

  /// Create a new wallet.
  Future<Wallet> create(CreateWalletParams params) async {
    final json = await _client.post('/v1/wallets', body: params.toJson());
    return Wallet.fromJson(json!);
  }

  /// Get a wallet by ID.
  Future<Wallet> get(String walletId) async {
    final json = await _client.get('/v1/wallets/$walletId');
    return Wallet.fromJson(json!);
  }

  /// Get a wallet by owner user ID.
  Future<Wallet> getByOwner(String userId) async {
    final json = await _client.get('/v1/wallets/by-owner', query: {'user_id': userId});
    return Wallet.fromJson(json!);
  }

  /// Get wallet balance.
  Future<Balance> getBalance(String walletId) async {
    final json = await _client.get('/v1/wallets/$walletId/balance');
    return Balance.fromJson(json!);
  }

  // ── Transfers ──

  /// Transfer funds between wallets.
  Future<TransferResult> transfer(TransferParams params) async {
    final json = await _client.post('/v1/wallets/transfers', body: params.toJson());
    return TransferResult.fromJson(json!);
  }

  /// Get transaction history for a wallet.
  Future<ListResponse<TransactionEntry>> listTransactions(String walletId, {int? page, int? perPage}) async {
    final json = await _client.get('/v1/wallets/$walletId/transactions', query: {
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, TransactionEntry.fromJson);
  }

  // ── Deposits & Withdrawals ──

  /// Initiate a deposit (fund wallet via mobile money).
  Future<DepositResult> initiateDeposit(InitiateDepositParams params) async {
    final json = await _client.post('/v1/wallets/deposits', body: params.toJson());
    return DepositResult.fromJson(json!);
  }

  /// Initiate a withdrawal (cash out to mobile money).
  Future<WithdrawalResult> initiateWithdrawal(InitiateWithdrawalParams params) async {
    final json = await _client.post('/v1/wallets/withdrawals', body: params.toJson());
    return WithdrawalResult.fromJson(json!);
  }

  // ── Wallet Roles (RBAC) ──

  /// Create a role for a shared wallet.
  Future<WalletRole> createRole(CreateWalletRoleParams params) async {
    final json = await _client.post('/v1/wallets/roles', body: params.toJson());
    return WalletRole.fromJson(json!);
  }

  /// List roles for a wallet.
  Future<ListResponse<WalletRole>> listRoles(String walletId) async {
    final json = await _client.get('/v1/wallets/$walletId/roles');
    return ListResponse.fromJson(json!, WalletRole.fromJson);
  }

  /// Update a wallet role.
  Future<WalletRole> updateRole(String roleId, {String? name, List<String>? permissions}) async {
    final json = await _client.patch('/v1/wallets/roles/$roleId', body: {
      if (name != null) 'name': name,
      if (permissions != null) 'permissions': permissions,
    });
    return WalletRole.fromJson(json!);
  }

  /// Delete a wallet role.
  Future<void> deleteRole(String roleId) async {
    await _client.delete('/v1/wallets/roles/$roleId');
  }

  // ── Wallet Members ──

  /// Add a member to a shared wallet.
  Future<WalletMember> addMember(AddWalletMemberParams params) async {
    final json = await _client.post('/v1/wallets/members', body: params.toJson());
    return WalletMember.fromJson(json!);
  }

  /// List members of a wallet.
  Future<ListResponse<WalletMember>> listMembers(String walletId) async {
    final json = await _client.get('/v1/wallets/$walletId/members');
    return ListResponse.fromJson(json!, WalletMember.fromJson);
  }

  /// Update a member's role.
  Future<WalletMember> updateMemberRole(String memberId, String roleId) async {
    final json = await _client.patch('/v1/wallets/members/$memberId', body: {'role_id': roleId});
    return WalletMember.fromJson(json!);
  }

  /// Remove a member from a wallet.
  Future<void> removeMember(String memberId) async {
    await _client.delete('/v1/wallets/members/$memberId');
  }
}
