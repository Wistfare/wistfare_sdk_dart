import 'package:wistfare_core/wistfare_core.dart';

import 'types.dart';

/// Wistfare Payments client — collections, disbursements, fees & payment requests.
class PaymentsClient {
  final Wistfare _client;

  PaymentsClient(this._client);

  // ── Fee Management ──

  /// Configure fees for a business.
  Future<FeeConfig> setFeeConfig(SetFeeConfigParams params) async {
    final json = await _client.post('/v1/fees', body: params.toJson());
    return FeeConfig.fromJson(json!);
  }

  /// Get fee configuration for a business and transaction type.
  Future<FeeConfig> getFeeConfig(String businessId, String transactionType) async {
    final json = await _client.get('/v1/fees/$businessId', query: {'transaction_type': transactionType});
    return FeeConfig.fromJson(json!);
  }

  /// List all fee configs for a business.
  Future<ListResponse<FeeConfig>> listFeeConfigs(String businessId, {int? page, int? perPage}) async {
    final json = await _client.get('/v1/fees', query: {
      'business_id': businessId,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, FeeConfig.fromJson);
  }

  /// Delete a fee config.
  Future<void> deleteFeeConfig(String feeConfigId) async {
    await _client.delete('/v1/fees/$feeConfigId');
  }

  /// Calculate fee for a given amount and business.
  Future<CalculateFeeResult> calculateFee(CalculateFeeParams params) async {
    final json = await _client.post('/v1/fees/calculate', body: params.toJson());
    return CalculateFeeResult.fromJson(json!);
  }

  // ── Payment Requests (QR / Links) ──

  /// Create a payment request (generates QR code or payment link).
  Future<PaymentRequest> createPaymentRequest(CreatePaymentRequestParams params) async {
    final json = await _client.post('/v1/payment-requests', body: params.toJson());
    return PaymentRequest.fromJson(json!);
  }

  /// Get a payment request by ID.
  Future<PaymentRequest> getPaymentRequest(String requestId) async {
    final json = await _client.get('/v1/payment-requests/$requestId');
    return PaymentRequest.fromJson(json!);
  }

  /// List payment requests for a business.
  Future<ListResponse<PaymentRequest>> listPaymentRequests(String businessId, {int? page, int? perPage}) async {
    final json = await _client.get('/v1/payment-requests', query: {
      'business_id': businessId,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, PaymentRequest.fromJson);
  }

  /// Cancel a payment request.
  Future<PaymentRequest> cancelPaymentRequest(String requestId) async {
    final json = await _client.post('/v1/payment-requests/$requestId/cancel');
    return PaymentRequest.fromJson(json!);
  }

  // ── Collections (charge customer) ──

  /// Initiate a mobile money collection from a customer.
  Future<CollectionResponse> initiateCollection(InitiateCollectionParams params) async {
    final json = await _client.post('/v1/collections', body: params.toJson());
    return CollectionResponse.fromJson(json!);
  }

  // ── Transactions ──

  /// Get a payment transaction by ID.
  Future<PaymentTransaction> getTransaction(String transactionId) async {
    final json = await _client.get('/v1/transactions/$transactionId');
    return PaymentTransaction.fromJson(json!);
  }

  /// List payment transactions with optional filters.
  Future<ListResponse<PaymentTransaction>> listTransactions(
    String businessId, {
    String? status,
    String? fromDate,
    String? toDate,
    String? paymentMethod,
    int? page,
    int? perPage,
  }) async {
    final json = await _client.get('/v1/transactions', query: {
      'business_id': businessId,
      if (status != null) 'status': status,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, PaymentTransaction.fromJson);
  }

  // ── Disbursements (pay out to customer) ──

  /// Initiate a disbursement (payout) to a mobile money number.
  Future<DisbursementResponse> initiateDisbursement(InitiateDisbursementParams params) async {
    final json = await _client.post('/v1/disbursements', body: params.toJson());
    return DisbursementResponse.fromJson(json!);
  }

  /// Get a disbursement by ID.
  Future<Disbursement> getDisbursement(String disbursementId) async {
    final json = await _client.get('/v1/disbursements/$disbursementId');
    return Disbursement.fromJson(json!);
  }

  /// List disbursements for a business.
  Future<ListResponse<Disbursement>> listDisbursements(String businessId, {int? page, int? perPage}) async {
    final json = await _client.get('/v1/disbursements', query: {
      'business_id': businessId,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, Disbursement.fromJson);
  }
}
