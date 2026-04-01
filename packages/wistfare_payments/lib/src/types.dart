import 'dart:convert';

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
  percentagePlusFlat,
  mixed;

  String toJson() => switch (this) {
        percentage => 'percentage',
        flat => 'flat',
        percentagePlusFlat => 'percentage_plus_flat',
        mixed => 'mixed',
      };

  static FeeModel fromString(String value) => switch (value) {
        'percentage' => percentage,
        'flat' => flat,
        'percentage_plus_flat' => percentagePlusFlat,
        'mixed' => mixed,
        _ => throw ArgumentError('Unknown FeeModel: $value'),
      };
}

/// Payment request (QR codes, payment links).
class PaymentRequest {
  final String id;
  final String businessId;
  final String walletId;
  final PaymentRequestType requestType;
  final String shortCode;
  final String? amount;
  final String currency;
  final String? description;
  final String? customerPhone;
  final String? customerName;
  final PaymentRequestStatus status;
  final String? qrData;
  final int maxUses;
  final int useCount;
  final String? expiresAt;
  final String createdAt;

  const PaymentRequest({
    required this.id,
    required this.businessId,
    required this.walletId,
    required this.requestType,
    required this.shortCode,
    this.amount,
    required this.currency,
    this.description,
    this.customerPhone,
    this.customerName,
    required this.status,
    this.qrData,
    required this.maxUses,
    required this.useCount,
    this.expiresAt,
    required this.createdAt,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
        id: json['id'] as String,
        businessId: json['business_id'] as String,
        walletId: json['wallet_id'] as String,
        requestType: PaymentRequestType.fromString(json['request_type'] as String),
        shortCode: json['short_code'] as String? ?? '',
        amount: json['amount'] as String?,
        currency: json['currency'] as String? ?? 'RWF',
        description: json['description'] as String?,
        customerPhone: json['customer_phone'] as String?,
        customerName: json['customer_name'] as String?,
        status: PaymentRequestStatus.fromString(json['status'] as String),
        qrData: json['qr_data'] as String?,
        maxUses: json['max_uses'] as int? ?? 0,
        useCount: json['use_count'] as int? ?? 0,
        expiresAt: json['expires_at'] as String?,
        createdAt: json['created_at'] as String,
      );
}

enum PaymentRequestType {
  oneTime,
  recurring,
  openAmount,
  qrStatic,
  qrDynamic,
  paymentLink,
  paymentPrompt;

  String toJson() => switch (this) {
        oneTime => 'one_time',
        recurring => 'recurring',
        openAmount => 'open_amount',
        qrStatic => 'qr_static',
        qrDynamic => 'qr_dynamic',
        paymentLink => 'payment_link',
        paymentPrompt => 'payment_prompt',
      };

  static PaymentRequestType fromString(String value) => switch (value) {
        'one_time' => oneTime,
        'recurring' => recurring,
        'open_amount' => openAmount,
        'qr_static' => qrStatic,
        'qr_dynamic' => qrDynamic,
        'payment_link' => paymentLink,
        'payment_prompt' => paymentPrompt,
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
  final String referenceId;
  final String description;
  final String? failureReason;
  final String createdAt;
  final String? confirmedAt;

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
    required this.referenceId,
    required this.description,
    this.failureReason,
    required this.createdAt,
    this.confirmedAt,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) => PaymentTransaction(
        id: json['id'] as String,
        paymentRequestId: json['payment_request_id'] as String? ?? '',
        businessId: json['business_id'] as String,
        businessWalletId: json['business_wallet_id'] as String,
        customerPhone: json['customer_phone'] as String? ?? '',
        customerName: json['customer_name'] as String? ?? '',
        amount: json['amount'] as String,
        feeAmount: json['fee_amount'] as String? ?? '0',
        netAmount: json['net_amount'] as String? ?? '0',
        currency: json['currency'] as String,
        paymentMethod: json['payment_method'] as String,
        status: TransactionStatus.fromString(json['status'] as String),
        azampayReference: json['azampay_reference'] as String? ?? '',
        referenceId: json['reference_id'] as String? ?? '',
        description: json['description'] as String? ?? '',
        failureReason: json['failure_reason'] as String?,
        createdAt: json['created_at'] as String,
        confirmedAt: json['confirmed_at'] as String?,
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
  final String? customerName;
  final String amount;
  final String paymentMethod;
  final String currency;
  final String? description;
  final String? referenceId;
  final String? paymentRequestId;

  const InitiateCollectionParams({
    required this.businessId,
    required this.walletId,
    required this.customerPhone,
    this.customerName,
    required this.amount,
    required this.paymentMethod,
    this.currency = 'RWF',
    this.description,
    this.referenceId,
    this.paymentRequestId,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'wallet_id': walletId,
        'customer_phone': customerPhone,
        if (customerName != null) 'customer_name': customerName,
        'amount': amount,
        'payment_method': paymentMethod,
        'currency': currency,
        if (description != null) 'description': description,
        if (referenceId != null) 'reference_id': referenceId,
        if (paymentRequestId != null) 'payment_request_id': paymentRequestId,
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
  final String referenceId;

  const InitiateDisbursementParams({
    required this.businessId,
    required this.walletId,
    required this.amount,
    required this.destinationType,
    required this.destinationRef,
    this.destinationName,
    this.currency,
    this.description,
    required this.referenceId,
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
        'reference_id': referenceId,
      };
}

// ── Webhooks ──

/// Webhook event types sent by Wistfare.
enum WebhookEvent {
  collectionCompleted,
  collectionFailed,
  disbursementCompleted,
  disbursementFailed;

  static WebhookEvent fromString(String value) => switch (value) {
        'collection.completed' => collectionCompleted,
        'collection.failed' => collectionFailed,
        'disbursement.completed' => disbursementCompleted,
        'disbursement.failed' => disbursementFailed,
        _ => throw ArgumentError('Unknown WebhookEvent: $value'),
      };
}

/// Webhook transaction type.
enum WebhookTransactionType {
  collection,
  disbursement;

  static WebhookTransactionType fromString(String value) => switch (value) {
        'collection' => collection,
        'disbursement' => disbursement,
        _ => throw ArgumentError('Unknown WebhookTransactionType: $value'),
      };
}

/// Payload delivered to your webhook endpoint.
class WebhookPayload {
  /// One of the webhook event types (e.g. `collection.completed`, `payment.failed`).
  final WebhookEvent event;

  /// Unique Wistfare transaction identifier.
  final String transactionId;

  /// `collection` or `disbursement`.
  final WebhookTransactionType transactionType;

  /// Terminal status: `pending`, `completed`, `failed`, or `expired`.
  final String status;

  /// Original transaction amount.
  final String amount;

  /// Fee deducted from the transaction.
  final String feeAmount;

  /// Amount after fees.
  final String netAmount;

  /// Currency code (e.g. `RWF`).
  final String currency;

  /// The business wallet involved.
  final String businessWalletId;

  /// Customer phone number.
  final String customerPhone;

  /// Customer display name (may be empty).
  final String customerName;

  /// Payment rail used (e.g. `mtn_momo`, `airtel_money`).
  final String paymentMethod;

  /// Your original reference ID passed when creating the collection or disbursement.
  final String referenceId;

  /// Human-readable description.
  final String description;

  /// Empty on success; contains the error message on failure.
  final String failureReason;

  /// ISO 8601 timestamp of the event.
  final String timestamp;

  const WebhookPayload({
    required this.event,
    required this.transactionId,
    required this.transactionType,
    required this.status,
    required this.amount,
    required this.feeAmount,
    required this.netAmount,
    required this.currency,
    required this.businessWalletId,
    required this.customerPhone,
    required this.customerName,
    required this.paymentMethod,
    required this.referenceId,
    required this.description,
    required this.failureReason,
    required this.timestamp,
  });

  factory WebhookPayload.fromJson(Map<String, dynamic> json) => WebhookPayload(
        event: WebhookEvent.fromString(json['event'] as String),
        transactionId: json['transaction_id'] as String,
        transactionType: WebhookTransactionType.fromString(json['transaction_type'] as String),
        status: json['status'] as String,
        amount: json['amount'] as String,
        feeAmount: json['fee_amount'] as String,
        netAmount: json['net_amount'] as String,
        currency: json['currency'] as String,
        businessWalletId: json['business_wallet_id'] as String,
        customerPhone: json['customer_phone'] as String,
        customerName: json['customer_name'] as String? ?? '',
        paymentMethod: json['payment_method'] as String,
        referenceId: json['reference_id'] as String? ?? '',
        description: json['description'] as String? ?? '',
        failureReason: json['failure_reason'] as String? ?? '',
        timestamp: json['timestamp'] as String,
      );
}

/// Parse a raw webhook request body into a [WebhookPayload].
WebhookPayload parseWebhookPayload(String body) {
  final json = Map<String, dynamic>.from(
    const JsonCodec().decode(body) as Map,
  );
  return WebhookPayload.fromJson(json);
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
