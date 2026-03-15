/// Wallet resource.
class Wallet {
  final String id;
  final String userId;
  final WalletType walletType;
  final String kycTier;
  final WalletState state;
  final String balance;
  final String currency;
  final bool azampayLinked;
  final String createdAt;

  const Wallet({
    required this.id,
    required this.userId,
    required this.walletType,
    required this.kycTier,
    required this.state,
    required this.balance,
    required this.currency,
    required this.azampayLinked,
    required this.createdAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        walletType: WalletType.fromString(json['wallet_type'] as String),
        kycTier: json['kyc_tier'] as String,
        state: WalletState.fromString(json['state'] as String),
        balance: json['balance'] as String,
        currency: json['currency'] as String,
        azampayLinked: json['azampay_linked'] as bool,
        createdAt: json['created_at'] as String,
      );
}

enum WalletType {
  personal,
  business;

  static WalletType fromString(String value) => switch (value) {
        'personal' => personal,
        'business' => business,
        _ => throw ArgumentError('Unknown WalletType: $value'),
      };
}

enum WalletState {
  active,
  suspended,
  closed;

  static WalletState fromString(String value) => switch (value) {
        'active' => active,
        'suspended' => suspended,
        'closed' => closed,
        _ => throw ArgumentError('Unknown WalletState: $value'),
      };
}

/// Parameters for creating a wallet.
class CreateWalletParams {
  final String userId;
  final WalletType walletType;
  final String? currency;

  const CreateWalletParams({
    required this.userId,
    required this.walletType,
    this.currency,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'wallet_type': walletType.name,
        if (currency != null) 'currency': currency,
      };
}

/// Balance response.
class Balance {
  final String walletId;
  final String availableBalance;
  final String pendingBalance;
  final String currency;
  final String asOf;

  const Balance({
    required this.walletId,
    required this.availableBalance,
    required this.pendingBalance,
    required this.currency,
    required this.asOf,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        walletId: json['wallet_id'] as String,
        availableBalance: json['available_balance'] as String,
        pendingBalance: json['pending_balance'] as String,
        currency: json['currency'] as String,
        asOf: json['as_of'] as String,
      );
}

/// Transfer between wallets.
class TransferParams {
  final String fromWalletId;
  final String toWalletId;
  final String amount;
  final String? description;
  final String idempotencyKey;

  const TransferParams({
    required this.fromWalletId,
    required this.toWalletId,
    required this.amount,
    this.description,
    required this.idempotencyKey,
  });

  Map<String, dynamic> toJson() => {
        'from_wallet_id': fromWalletId,
        'to_wallet_id': toWalletId,
        'amount': amount,
        if (description != null) 'description': description,
        'idempotency_key': idempotencyKey,
      };
}

/// Transfer result.
class TransferResult {
  final String transactionId;
  final String status;
  final String fromBalance;
  final String toBalance;
  final String amount;
  final String fee;
  final String currency;
  final String createdAt;

  const TransferResult({
    required this.transactionId,
    required this.status,
    required this.fromBalance,
    required this.toBalance,
    required this.amount,
    required this.fee,
    required this.currency,
    required this.createdAt,
  });

  factory TransferResult.fromJson(Map<String, dynamic> json) => TransferResult(
        transactionId: json['transaction_id'] as String,
        status: json['status'] as String,
        fromBalance: json['from_balance'] as String,
        toBalance: json['to_balance'] as String,
        amount: json['amount'] as String,
        fee: json['fee'] as String,
        currency: json['currency'] as String,
        createdAt: json['created_at'] as String,
      );
}

/// Transaction history entry.
class TransactionEntry {
  final String id;
  final String transactionType;
  final String fromWalletId;
  final String toWalletId;
  final String amount;
  final String fee;
  final String currency;
  final String status;
  final String entryHash;
  final String description;
  final String createdAt;
  final String confirmedAt;

  const TransactionEntry({
    required this.id,
    required this.transactionType,
    required this.fromWalletId,
    required this.toWalletId,
    required this.amount,
    required this.fee,
    required this.currency,
    required this.status,
    required this.entryHash,
    required this.description,
    required this.createdAt,
    required this.confirmedAt,
  });

  factory TransactionEntry.fromJson(Map<String, dynamic> json) => TransactionEntry(
        id: json['id'] as String,
        transactionType: json['transaction_type'] as String,
        fromWalletId: json['from_wallet_id'] as String,
        toWalletId: json['to_wallet_id'] as String,
        amount: json['amount'] as String,
        fee: json['fee'] as String,
        currency: json['currency'] as String,
        status: json['status'] as String,
        entryHash: json['entry_hash'] as String,
        description: json['description'] as String,
        createdAt: json['created_at'] as String,
        confirmedAt: json['confirmed_at'] as String,
      );
}

/// Parameters for initiating a deposit.
class InitiateDepositParams {
  final String walletId;
  final String amount;
  final String paymentMethod;
  final String phoneNumber;
  final String? currency;

  const InitiateDepositParams({
    required this.walletId,
    required this.amount,
    required this.paymentMethod,
    required this.phoneNumber,
    this.currency,
  });

  Map<String, dynamic> toJson() => {
        'wallet_id': walletId,
        'amount': amount,
        'payment_method': paymentMethod,
        'phone_number': phoneNumber,
        if (currency != null) 'currency': currency,
      };
}

/// Deposit result.
class DepositResult {
  final String depositId;
  final String status;
  final String paymentUrl;
  final String instructions;

  const DepositResult({
    required this.depositId,
    required this.status,
    required this.paymentUrl,
    required this.instructions,
  });

  factory DepositResult.fromJson(Map<String, dynamic> json) => DepositResult(
        depositId: json['deposit_id'] as String,
        status: json['status'] as String,
        paymentUrl: json['payment_url'] as String,
        instructions: json['instructions'] as String,
      );
}

/// Parameters for initiating a withdrawal.
class InitiateWithdrawalParams {
  final String walletId;
  final String amount;
  final String destinationType;
  final String destinationRef;
  final String? currency;

  const InitiateWithdrawalParams({
    required this.walletId,
    required this.amount,
    required this.destinationType,
    required this.destinationRef,
    this.currency,
  });

  Map<String, dynamic> toJson() => {
        'wallet_id': walletId,
        'amount': amount,
        'destination_type': destinationType,
        'destination_ref': destinationRef,
        if (currency != null) 'currency': currency,
      };
}

/// Withdrawal result.
class WithdrawalResult {
  final String withdrawalId;
  final String status;
  final String estimatedArrival;

  const WithdrawalResult({
    required this.withdrawalId,
    required this.status,
    required this.estimatedArrival,
  });

  factory WithdrawalResult.fromJson(Map<String, dynamic> json) => WithdrawalResult(
        withdrawalId: json['withdrawal_id'] as String,
        status: json['status'] as String,
        estimatedArrival: json['estimated_arrival'] as String,
      );
}

/// Wallet role (RBAC for shared wallets).
class WalletRole {
  final String id;
  final String walletId;
  final String name;
  final List<String> permissions;
  final bool isSystem;
  final String createdBy;
  final String createdAt;

  const WalletRole({
    required this.id,
    required this.walletId,
    required this.name,
    required this.permissions,
    required this.isSystem,
    required this.createdBy,
    required this.createdAt,
  });

  factory WalletRole.fromJson(Map<String, dynamic> json) => WalletRole(
        id: json['id'] as String,
        walletId: json['wallet_id'] as String,
        name: json['name'] as String,
        permissions: (json['permissions'] as List).cast<String>(),
        isSystem: json['is_system'] as bool,
        createdBy: json['created_by'] as String,
        createdAt: json['created_at'] as String,
      );
}

/// Parameters for creating a wallet role.
class CreateWalletRoleParams {
  final String walletId;
  final String name;
  final List<String> permissions;

  const CreateWalletRoleParams({
    required this.walletId,
    required this.name,
    required this.permissions,
  });

  Map<String, dynamic> toJson() => {
        'wallet_id': walletId,
        'name': name,
        'permissions': permissions,
      };
}

/// Wallet member.
class WalletMember {
  final String id;
  final String walletId;
  final String userId;
  final String roleId;
  final String roleName;
  final List<String> permissions;
  final String grantedBy;
  final String createdAt;

  const WalletMember({
    required this.id,
    required this.walletId,
    required this.userId,
    required this.roleId,
    required this.roleName,
    required this.permissions,
    required this.grantedBy,
    required this.createdAt,
  });

  factory WalletMember.fromJson(Map<String, dynamic> json) => WalletMember(
        id: json['id'] as String,
        walletId: json['wallet_id'] as String,
        userId: json['user_id'] as String,
        roleId: json['role_id'] as String,
        roleName: json['role_name'] as String,
        permissions: (json['permissions'] as List).cast<String>(),
        grantedBy: json['granted_by'] as String,
        createdAt: json['created_at'] as String,
      );
}

/// Parameters for adding a wallet member.
class AddWalletMemberParams {
  final String walletId;
  final String userId;
  final String roleId;

  const AddWalletMemberParams({
    required this.walletId,
    required this.userId,
    required this.roleId,
  });

  Map<String, dynamic> toJson() => {
        'wallet_id': walletId,
        'user_id': userId,
        'role_id': roleId,
      };
}
