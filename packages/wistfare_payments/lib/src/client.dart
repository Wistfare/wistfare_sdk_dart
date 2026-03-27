import 'package:wistfare_core/wistfare_core.dart';

import 'types.dart';

/// Wistfare Payments client — collections, disbursements, fees & payment requests.
class PaymentsClient {
  final Wistfare _client;

  PaymentsClient(this._client);

  // ── Fee Management ──

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

  // ── Collections (charge customer) ──

  /// Initiate a mobile money collection from a customer.
  Future<CollectionResponse> initiateCollection(InitiateCollectionParams params) async {
    final json = await _client.post('/v1/collections', body: params.toJson());
    return CollectionResponse.fromJson(json!);
  }

  /// List collections with optional filters.
  Future<ListResponse<PaymentTransaction>> listCollections({
    String? businessId,
    String? referenceId,
    String? status,
    String? fromDate,
    String? toDate,
    int? page,
    int? perPage,
  }) async {
    final json = await _client.get('/v1/collections', query: {
      if (businessId != null) 'business_id': businessId,
      if (referenceId != null) 'reference_id': referenceId,
      if (status != null) 'status': status,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, PaymentTransaction.fromJson);
  }

  // ── Payment Requests (QR / Links) ──

  /// Create a payment request (generates QR code or payment link).
  Future<PaymentRequest> createPaymentRequest(CreatePaymentRequestParams params) async {
    final json = await _client.post('/v1/payment-requests', body: params.toJson());
    return PaymentRequest.fromJson(json!);
  }

  // ── Disbursements (pay out to customer) ──

  /// Initiate a disbursement (payout) to a mobile money number.
  Future<DisbursementResponse> initiateDisbursement(InitiateDisbursementParams params) async {
    final json = await _client.post('/v1/disbursements', body: params.toJson());
    return DisbursementResponse.fromJson(json!);
  }
}
