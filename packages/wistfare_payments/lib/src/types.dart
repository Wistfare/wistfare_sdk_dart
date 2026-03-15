/// Fee configuration for a business.
class FeeConfig {
  final String id;
  final String businessId;
  final TransactionType transactionType;
  final FeeModel feeModel;
  final String percentageRate;
  final String flatAmount;
  final String minFee;
  final String maxFee;
  final String currency;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const FeeConfig({
    required this.id,
    required this.businessId,
    required this.transactionType,
    required this.feeModel,
    required this.percentageRate,
    required this.flatAmount,
    required this.minFee,
    required this.maxFee,
    required this.currency,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeeConfig.fromJson(Map<String, dynamic> json) => FeeConfig(
        id: json['id'] as String,
        businessId: json['business_id'] as String,
        transactionType: TransactionType.fromString(json['transaction_type'] as String),
        feeModel: FeeModel.fromString(json['fee_model'] as String),
        percentageRate: json['percentage_rate'] as String,
        flatAmount: json['flat_amount'] as String,
        minFee: json['min_fee'] as String,
        maxFee: json['max_fee'] as String,
        currency: json['currency'] as String,
        isActive: json['is_active'] as bool,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
      );
}

enum TransactionType {
  collection,
  disbursement;

  static TransactionType fromString(String value) => switch (value) {
        'collection' => collection,
        'disbursement' => disbursement,
        _ => throw ArgumentError('Unknown TransactionType: $value'),
      };
}

enum FeeModel {
  percentage,
  flat,
  percentagePlusFlat;

  String toJson() => switch (this) {
        percentage => 'percentage',
        flat => 'flat',
        percentagePlusFlat => 'percentage_plus_flat',
      };

  static FeeModel fromString(String value) => switch (value) {
        'percentage' => percentage,
        'flat' => flat,
        'percentage_plus_flat' => percentagePlusFlat,
        _ => throw ArgumentError('Unknown FeeModel: $value'),
      };
}

/// Parameters for setting a fee configuration.
class SetFeeConfigParams {
  final String businessId;
  final TransactionType transactionType;
  final FeeModel feeModel;
  final String? percentageRate;
  final String? flatAmount;
  final String? minFee;
  final String? maxFee;
  final String? currency;

  const SetFeeConfigParams({
    required this.businessId,
    required this.transactionType,
    required this.feeModel,
    this.percentageRate,
    this.flatAmount,
    this.minFee,
    this.maxFee,
    this.currency,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'transaction_type': transactionType.name,
        'fee_model': feeModel.toJson(),
        if (percentageRate != null) 'percentage_rate': percentageRate,
        if (flatAmount != null) 'flat_amount': flatAmount,
        if (minFee != null) 'min_fee': minFee,
        if (maxFee != null) 'max_fee': maxFee,
        if (currency != null) 'currency': currency,
      };
}

/// Payment request (QR codes, payment links).
class PaymentRequest {
  final String id;
  final String businessId;
  final String walletId;
  final PaymentRequestType requestType;
  final String shortCode;
  final String amount;
  final String currency;
  final String description;
  final String customerPhone;
  final String customerName;
  final PaymentRequestStatus status;
  final String qrData;
  final int maxUses;
  final int useCount;
  final String expiresAt;
  final String createdAt;

  const PaymentRequest({
    required this.id,
    required this.businessId,
    required this.walletId,
    required this.requestType,
    required this.shortCode,
    required this.amount,
    required this.currency,
    required this.description,
    required this.customerPhone,
    required this.customerName,
    required this.status,
    required this.qrData,
    required this.maxUses,
    required this.useCount,
    required this.expiresAt,
    required this.createdAt,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
        id: json['id'] as String,
        businessId: json['business_id'] as String,
        walletId: json['wallet_id'] as String,
        requestType: PaymentRequestType.fromString(json['request_type'] as String),
        shortCode: json['short_code'] as String,
        amount: json['amount'] as String,
        currency: json['currency'] as String,
        description: json['description'] as String,
        customerPhone: json['customer_phone'] as String,
        customerName: json['customer_name'] as String,
        status: PaymentRequestStatus.fromString(json['status'] as String),
        qrData: json['qr_data'] as String,
        maxUses: json['max_uses'] as int,
        useCount: json['use_count'] as int,
        expiresAt: json['expires_at'] as String,
        createdAt: json['created_at'] as String,
      );
}

enum PaymentRequestType {
  oneTime,
  recurring,
  openAmount;

  String toJson() => switch (this) {
        oneTime => 'one_time',
        recurring => 'recurring',
        openAmount => 'open_amount',
      };

  static PaymentRequestType fromString(String value) => switch (value) {
        'one_time' => oneTime,
        'recurring' => recurring,
        'open_amount' => openAmount,
        _ => throw ArgumentError('Unknown PaymentRequestType: $value'),
      };
}

enum PaymentRequestStatus {
  active,
  completed,
  expired,
  cancelled;

  static PaymentRequestStatus fromString(String value) => switch (value) {
        'active' => active,
        'completed' => completed,
        'expired' => expired,
        'cancelled' => cancelled,
        _ => throw ArgumentError('Unknown PaymentRequestStatus: $value'),
      };
}

/// Parameters for creating a payment request.
class CreatePaymentRequestParams {
  final String businessId;
  final String walletId;
  final PaymentRequestType requestType;
  final String amount;
  final String? currency;
  final String? description;
  final String? customerPhone;
  final String? customerName;
  final int? maxUses;
  final String? expiresAt;

  const CreatePaymentRequestParams({
    required this.businessId,
    required this.walletId,
    required this.requestType,
    required this.amount,
    this.currency,
    this.description,
    this.customerPhone,
    this.customerName,
    this.maxUses,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'wallet_id': walletId,
        'request_type': requestType.toJson(),
        'amount': amount,
        if (currency != null) 'currency': currency,
        if (description != null) 'description': description,
        if (customerPhone != null) 'customer_phone': customerPhone,
        if (customerName != null) 'customer_name': customerName,
        if (maxUses != null) 'max_uses': maxUses,
        if (expiresAt != null) 'expires_at': expiresAt,
      };
}

/// Payment transaction.
class PaymentTransaction {
  final String id;
  final String paymentRequestId;
  final String businessId;
  final String businessWalletId;
  final String customerPhone;
  final String customerName;
  final String amount;
  final String feeAmount;
  final String netAmount;
  final String currency;
  final String paymentMethod;
  final TransactionStatus status;
  final String azampayReference;
  final String externalId;
  final String description;
  final String failureReason;
  final String createdAt;
  final String confirmedAt;

  const PaymentTransaction({
    required this.id,
    required this.paymentRequestId,
    required this.businessId,
    required this.businessWalletId,
    required this.customerPhone,
    required this.customerName,
    required this.amount,
    required this.feeAmount,
    required this.netAmount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    required this.azampayReference,
    required this.externalId,
    required this.description,
    required this.failureReason,
    required this.createdAt,
    required this.confirmedAt,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) => PaymentTransaction(
        id: json['id'] as String,
        paymentRequestId: json['payment_request_id'] as String,
        businessId: json['business_id'] as String,
        businessWalletId: json['business_wallet_id'] as String,
        customerPhone: json['customer_phone'] as String,
        customerName: json['customer_name'] as String,
        amount: json['amount'] as String,
        feeAmount: json['fee_amount'] as String,
        netAmount: json['net_amount'] as String,
        currency: json['currency'] as String,
        paymentMethod: json['payment_method'] as String,
        status: TransactionStatus.fromString(json['status'] as String),
        azampayReference: json['azampay_reference'] as String,
        externalId: json['external_id'] as String,
        description: json['description'] as String,
        failureReason: json['failure_reason'] as String,
        createdAt: json['created_at'] as String,
        confirmedAt: json['confirmed_at'] as String,
      );
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  refunded;

  static TransactionStatus fromString(String value) => switch (value) {
        'pending' => pending,
        'processing' => processing,
        'completed' => completed,
        'failed' => failed,
        'refunded' => refunded,
        _ => throw ArgumentError('Unknown TransactionStatus: $value'),
      };
}

/// Parameters for initiating a mobile money collection.
class InitiateCollectionParams {
  final String businessId;
  final String walletId;
  final String customerPhone;
  final String amount;
  final String paymentMethod;
  final String? currency;
  final String? description;
  final String? externalId;

  const InitiateCollectionParams({
    required this.businessId,
    required this.walletId,
    required this.customerPhone,
    required this.amount,
    required this.paymentMethod,
    this.currency,
    this.description,
    this.externalId,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'wallet_id': walletId,
        'customer_phone': customerPhone,
        'amount': amount,
        'payment_method': paymentMethod,
        if (currency != null) 'currency': currency,
        if (description != null) 'description': description,
        if (externalId != null) 'external_id': externalId,
      };
}

/// Collection response.
class CollectionResponse {
  final String transactionId;
  final TransactionStatus status;
  final String azampayReference;
  final String feeAmount;
  final String netAmount;
  final String message;

  const CollectionResponse({
    required this.transactionId,
    required this.status,
    required this.azampayReference,
    required this.feeAmount,
    required this.netAmount,
    required this.message,
  });

  factory CollectionResponse.fromJson(Map<String, dynamic> json) => CollectionResponse(
        transactionId: json['transaction_id'] as String,
        status: TransactionStatus.fromString(json['status'] as String),
        azampayReference: json['azampay_reference'] as String,
        feeAmount: json['fee_amount'] as String,
        netAmount: json['net_amount'] as String,
        message: json['message'] as String,
      );
}

/// Disbursement (payout to mobile money).
class Disbursement {
  final String id;
  final String businessId;
  final String walletId;
  final String amount;
  final String feeAmount;
  final String netAmount;
  final String currency;
  final String destinationType;
  final String destinationRef;
  final String destinationName;
  final TransactionStatus status;
  final String azampayReference;
  final String externalId;
  final String description;
  final String failureReason;
  final String idempotencyKey;
  final String createdAt;
  final String confirmedAt;

  const Disbursement({
    required this.id,
    required this.businessId,
    required this.walletId,
    required this.amount,
    required this.feeAmount,
    required this.netAmount,
    required this.currency,
    required this.destinationType,
    required this.destinationRef,
    required this.destinationName,
    required this.status,
    required this.azampayReference,
    required this.externalId,
    required this.description,
    required this.failureReason,
    required this.idempotencyKey,
    required this.createdAt,
    required this.confirmedAt,
  });

  factory Disbursement.fromJson(Map<String, dynamic> json) => Disbursement(
        id: json['id'] as String,
        businessId: json['business_id'] as String,
        walletId: json['wallet_id'] as String,
        amount: json['amount'] as String,
        feeAmount: json['fee_amount'] as String,
        netAmount: json['net_amount'] as String,
        currency: json['currency'] as String,
        destinationType: json['destination_type'] as String,
        destinationRef: json['destination_ref'] as String,
        destinationName: json['destination_name'] as String,
        status: TransactionStatus.fromString(json['status'] as String),
        azampayReference: json['azampay_reference'] as String,
        externalId: json['external_id'] as String,
        description: json['description'] as String,
        failureReason: json['failure_reason'] as String,
        idempotencyKey: json['idempotency_key'] as String,
        createdAt: json['created_at'] as String,
        confirmedAt: json['confirmed_at'] as String,
      );
}

/// Parameters for initiating a disbursement.
class InitiateDisbursementParams {
  final String businessId;
  final String walletId;
  final String amount;
  final String destinationType;
  final String destinationRef;
  final String? destinationName;
  final String? currency;
  final String? description;
  final String idempotencyKey;

  const InitiateDisbursementParams({
    required this.businessId,
    required this.walletId,
    required this.amount,
    required this.destinationType,
    required this.destinationRef,
    this.destinationName,
    this.currency,
    this.description,
    required this.idempotencyKey,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'wallet_id': walletId,
        'amount': amount,
        'destination_type': destinationType,
        'destination_ref': destinationRef,
        if (destinationName != null) 'destination_name': destinationName,
        if (currency != null) 'currency': currency,
        if (description != null) 'description': description,
        'idempotency_key': idempotencyKey,
      };
}

/// Disbursement initiation response.
class DisbursementResponse {
  final String disbursementId;
  final TransactionStatus status;
  final String feeAmount;
  final String netAmount;
  final String estimatedArrival;

  const DisbursementResponse({
    required this.disbursementId,
    required this.status,
    required this.feeAmount,
    required this.netAmount,
    required this.estimatedArrival,
  });

  factory DisbursementResponse.fromJson(Map<String, dynamic> json) => DisbursementResponse(
        disbursementId: json['disbursement_id'] as String,
        status: TransactionStatus.fromString(json['status'] as String),
        feeAmount: json['fee_amount'] as String,
        netAmount: json['net_amount'] as String,
        estimatedArrival: json['estimated_arrival'] as String,
      );
}

/// Fee calculation result.
class CalculateFeeResult {
  final String grossAmount;
  final String feeAmount;
  final String netAmount;
  final FeeModel feeModel;
  final String percentageRate;
  final String flatAmount;
  final String currency;

  const CalculateFeeResult({
    required this.grossAmount,
    required this.feeAmount,
    required this.netAmount,
    required this.feeModel,
    required this.percentageRate,
    required this.flatAmount,
    required this.currency,
  });

  factory CalculateFeeResult.fromJson(Map<String, dynamic> json) => CalculateFeeResult(
        grossAmount: json['gross_amount'] as String,
        feeAmount: json['fee_amount'] as String,
        netAmount: json['net_amount'] as String,
        feeModel: FeeModel.fromString(json['fee_model'] as String),
        percentageRate: json['percentage_rate'] as String,
        flatAmount: json['flat_amount'] as String,
        currency: json['currency'] as String,
      );
}

/// Parameters for fee calculation.
class CalculateFeeParams {
  final String businessId;
  final String amount;
  final TransactionType transactionType;
  final String? currency;

  const CalculateFeeParams({
    required this.businessId,
    required this.amount,
    required this.transactionType,
    this.currency,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'amount': amount,
        'transaction_type': transactionType.name,
        if (currency != null) 'currency': currency,
      };
}
