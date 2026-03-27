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
  final String name;
  final String description;
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
    required this.name,
    required this.description,
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
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
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
  created,
  active,
  suspended,
  frozen,
  closed;

  static WalletState fromString(String value) => switch (value) {
        'created' => created,
        'active' => active,
        'suspended' => suspended,
        'frozen' => frozen,
        'closed' => closed,
        _ => throw ArgumentError('Unknown WalletState: $value'),
      };
}

/// Transfer between wallets.
class TransferParams {
  final String fromWalletId;
  final String toWalletId;
  final String amount;
  final String? description;
  final String referenceId;

  const TransferParams({
    required this.fromWalletId,
    required this.toWalletId,
    required this.amount,
    this.description,
    required this.referenceId,
  });

  Map<String, dynamic> toJson() => {
        'from_wallet_id': fromWalletId,
        'to_wallet_id': toWalletId,
        'amount': amount,
        if (description != null) 'description': description,
        'reference_id': referenceId,
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
