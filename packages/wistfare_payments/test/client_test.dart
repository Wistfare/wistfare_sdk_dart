import 'package:test/test.dart';
import 'package:wistfare_core/wistfare_core.dart';
import 'package:wistfare_payments/wistfare_payments.dart';

/// Mock Wistfare client that records HTTP calls and returns predefined responses.
class MockWistfare extends Wistfare {
  final List<({String method, String path, Map<String, dynamic>? body, Map<String, String>? query})> calls = [];
  Map<String, dynamic>? nextResponse;

  MockWistfare() : super(apiKey: 'wf_test_mock');

  @override
  Future<Map<String, dynamic>?> get(String path, {Map<String, String>? query}) async {
    calls.add((method: 'GET', path: path, body: null, query: query));
    return nextResponse;
  }

  @override
  Future<Map<String, dynamic>?> post(String path, {Map<String, dynamic>? body}) async {
    calls.add((method: 'POST', path: path, body: body, query: null));
    return nextResponse;
  }

  @override
  Future<Map<String, dynamic>?> patch(String path, {Map<String, dynamic>? body}) async {
    calls.add((method: 'PATCH', path: path, body: body, query: null));
    return nextResponse;
  }

  @override
  Future<Map<String, dynamic>?> delete(String path) async {
    calls.add((method: 'DELETE', path: path, body: null, query: null));
    return nextResponse;
  }
}

Map<String, dynamic> _feeConfigJson() => {
      'id': 'fee_1',
      'business_id': 'biz_1',
      'transaction_type': 'collection',
      'fee_model': 'percentage',
      'percentage_rate': '2.5',
      'flat_amount': '0',
      'min_fee': '100',
      'max_fee': '5000',
      'currency': 'RWF',
      'is_active': true,
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-02T00:00:00Z',
    };

Map<String, dynamic> _paymentRequestJson() => {
      'id': 'pr_1',
      'business_id': 'biz_1',
      'wallet_id': 'wal_1',
      'request_type': 'one_time',
      'short_code': 'ABC123',
      'amount': '5000',
      'currency': 'RWF',
      'description': 'Test',
      'customer_phone': '+250781234567',
      'customer_name': 'John',
      'status': 'active',
      'qr_data': 'qr_data',
      'max_uses': 1,
      'use_count': 0,
      'expires_at': '2026-02-01T00:00:00Z',
      'created_at': '2026-01-01T00:00:00Z',
    };

Map<String, dynamic> _transactionJson() => {
      'id': 'txn_1',
      'payment_request_id': 'pr_1',
      'business_id': 'biz_1',
      'business_wallet_id': 'wal_1',
      'customer_phone': '+250781234567',
      'customer_name': 'Jane',
      'amount': '10000',
      'fee_amount': '250',
      'net_amount': '9750',
      'currency': 'RWF',
      'payment_method': 'mtn',
      'status': 'completed',
      'azampay_reference': 'az_ref',
      'external_id': 'ext_1',
      'description': 'Payment',
      'failure_reason': '',
      'created_at': '2026-01-01T00:00:00Z',
      'confirmed_at': '2026-01-01T00:01:00Z',
    };

Map<String, dynamic> _disbursementJson() => {
      'id': 'disb_1',
      'business_id': 'biz_1',
      'wallet_id': 'wal_1',
      'amount': '5000',
      'fee_amount': '500',
      'net_amount': '4500',
      'currency': 'RWF',
      'destination_type': 'mobile_money',
      'destination_ref': '+250781234567',
      'destination_name': 'John',
      'status': 'pending',
      'azampay_reference': 'az_456',
      'external_id': 'ext_456',
      'description': 'Payout',
      'failure_reason': '',
      'idempotency_key': 'idem_1',
      'created_at': '2026-01-01T00:00:00Z',
      'confirmed_at': '',
    };

Map<String, dynamic> _listJson(List<Map<String, dynamic>> items) => {
      'data': items,
      'total': items.length,
      'page': 1,
      'per_page': 20,
      'has_more': false,
    };

void main() {
  late MockWistfare mock;
  late PaymentsClient client;

  setUp(() {
    mock = MockWistfare();
    client = PaymentsClient(mock);
  });

  group('PaymentsClient', () {
    // ── Fee Management ──

    test('setFeeConfig posts to /v1/fees', () async {
      mock.nextResponse = _feeConfigJson();
      const params = SetFeeConfigParams(
        businessId: 'biz_1',
        transactionType: TransactionType.collection,
        feeModel: FeeModel.percentage,
      );

      final result = await client.setFeeConfig(params);

      expect(mock.calls, hasLength(1));
      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/fees');
      expect(mock.calls.first.body!['business_id'], 'biz_1');
      expect(result.id, 'fee_1');
    });

    test('getFeeConfig gets /v1/fees/{businessId} with query', () async {
      mock.nextResponse = _feeConfigJson();

      final result = await client.getFeeConfig('biz_1', 'collection');

      expect(mock.calls, hasLength(1));
      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/fees/biz_1');
      expect(mock.calls.first.query, {'transaction_type': 'collection'});
      expect(result.id, 'fee_1');
    });

    test('listFeeConfigs gets /v1/fees with business_id', () async {
      mock.nextResponse = _listJson([_feeConfigJson()]);

      final result = await client.listFeeConfigs('biz_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/fees');
      expect(mock.calls.first.query!['business_id'], 'biz_1');
      expect(result.data, hasLength(1));
    });

    test('listFeeConfigs passes pagination params', () async {
      mock.nextResponse = _listJson([]);

      await client.listFeeConfigs('biz_1', page: 2, perPage: 10);

      expect(mock.calls.first.query!['page'], '2');
      expect(mock.calls.first.query!['per_page'], '10');
    });

    test('deleteFeeConfig deletes /v1/fees/{id}', () async {
      mock.nextResponse = null;

      await client.deleteFeeConfig('fee_1');

      expect(mock.calls.first.method, 'DELETE');
      expect(mock.calls.first.path, '/v1/fees/fee_1');
    });

    test('calculateFee posts to /v1/fees/calculate', () async {
      mock.nextResponse = {
        'gross_amount': '10000',
        'fee_amount': '250',
        'net_amount': '9750',
        'fee_model': 'percentage',
        'percentage_rate': '2.5',
        'flat_amount': '0',
        'currency': 'RWF',
      };
      const params = CalculateFeeParams(
        businessId: 'biz_1',
        amount: '10000',
        transactionType: TransactionType.collection,
      );

      final result = await client.calculateFee(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/fees/calculate');
      expect(result.grossAmount, '10000');
    });

    // ── Payment Requests ──

    test('createPaymentRequest posts to /v1/payment-requests', () async {
      mock.nextResponse = _paymentRequestJson();
      const params = CreatePaymentRequestParams(
        businessId: 'biz_1',
        walletId: 'wal_1',
        requestType: PaymentRequestType.oneTime,
        amount: '5000',
      );

      final result = await client.createPaymentRequest(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/payment-requests');
      expect(result.id, 'pr_1');
    });

    test('getPaymentRequest gets /v1/payment-requests/{id}', () async {
      mock.nextResponse = _paymentRequestJson();

      final result = await client.getPaymentRequest('pr_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/payment-requests/pr_1');
      expect(result.id, 'pr_1');
    });

    test('listPaymentRequests gets /v1/payment-requests', () async {
      mock.nextResponse = _listJson([_paymentRequestJson()]);

      final result = await client.listPaymentRequests('biz_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/payment-requests');
      expect(mock.calls.first.query!['business_id'], 'biz_1');
      expect(result.data, hasLength(1));
    });

    test('cancelPaymentRequest posts to /v1/payment-requests/{id}/cancel', () async {
      mock.nextResponse = _paymentRequestJson();

      final result = await client.cancelPaymentRequest('pr_1');

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/payment-requests/pr_1/cancel');
      expect(result.id, 'pr_1');
    });

    // ── Collections ──

    test('initiateCollection posts to /v1/collections', () async {
      mock.nextResponse = {
        'transaction_id': 'txn_1',
        'status': 'pending',
        'azampay_reference': 'az_123',
        'fee_amount': '100',
        'net_amount': '4900',
        'message': 'OK',
      };
      const params = InitiateCollectionParams(
        businessId: 'biz_1',
        walletId: 'wal_1',
        customerPhone: '+250781234567',
        amount: '5000',
        paymentMethod: 'mtn',
      );

      final result = await client.initiateCollection(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/collections');
      expect(mock.calls.first.body!['customer_phone'], '+250781234567');
      expect(result.transactionId, 'txn_1');
    });

    // ── Transactions ──

    test('getTransaction gets /v1/transactions/{id}', () async {
      mock.nextResponse = _transactionJson();

      final result = await client.getTransaction('txn_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/transactions/txn_1');
      expect(result.id, 'txn_1');
    });

    test('listTransactions gets /v1/transactions with filters', () async {
      mock.nextResponse = _listJson([_transactionJson()]);

      final result = await client.listTransactions(
        'biz_1',
        status: 'completed',
        fromDate: '2026-01-01',
        toDate: '2026-01-31',
        paymentMethod: 'mtn',
        page: 1,
        perPage: 10,
      );

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/transactions');
      final q = mock.calls.first.query!;
      expect(q['business_id'], 'biz_1');
      expect(q['status'], 'completed');
      expect(q['from_date'], '2026-01-01');
      expect(q['to_date'], '2026-01-31');
      expect(q['payment_method'], 'mtn');
      expect(q['page'], '1');
      expect(q['per_page'], '10');
      expect(result.data, hasLength(1));
    });

    test('listTransactions omits null filters', () async {
      mock.nextResponse = _listJson([]);

      await client.listTransactions('biz_1');

      final q = mock.calls.first.query!;
      expect(q['business_id'], 'biz_1');
      expect(q.containsKey('status'), isFalse);
      expect(q.containsKey('from_date'), isFalse);
    });

    // ── Disbursements ──

    test('initiateDisbursement posts to /v1/disbursements', () async {
      mock.nextResponse = {
        'disbursement_id': 'disb_1',
        'status': 'pending',
        'fee_amount': '500',
        'net_amount': '4500',
        'estimated_arrival': '2026-01-01T01:00:00Z',
      };
      const params = InitiateDisbursementParams(
        businessId: 'biz_1',
        walletId: 'wal_1',
        amount: '5000',
        destinationType: 'mobile_money',
        destinationRef: '+250781234567',
        idempotencyKey: 'idem_1',
      );

      final result = await client.initiateDisbursement(params);

      expect(mock.calls.first.method, 'POST');
      expect(mock.calls.first.path, '/v1/disbursements');
      expect(mock.calls.first.body!['idempotency_key'], 'idem_1');
      expect(result.disbursementId, 'disb_1');
    });

    test('getDisbursement gets /v1/disbursements/{id}', () async {
      mock.nextResponse = _disbursementJson();

      final result = await client.getDisbursement('disb_1');

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/disbursements/disb_1');
      expect(result.id, 'disb_1');
    });

    test('listDisbursements gets /v1/disbursements', () async {
      mock.nextResponse = _listJson([_disbursementJson()]);

      final result = await client.listDisbursements('biz_1', page: 1, perPage: 5);

      expect(mock.calls.first.method, 'GET');
      expect(mock.calls.first.path, '/v1/disbursements');
      expect(mock.calls.first.query!['business_id'], 'biz_1');
      expect(mock.calls.first.query!['page'], '1');
      expect(mock.calls.first.query!['per_page'], '5');
      expect(result.data, hasLength(1));
    });
  });
}
