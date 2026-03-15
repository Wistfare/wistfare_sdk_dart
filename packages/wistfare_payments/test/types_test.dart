import 'package:test/test.dart';
import 'package:wistfare_payments/wistfare_payments.dart';

void main() {
  group('TransactionType', () {
    test('fromString parses collection', () {
      expect(TransactionType.fromString('collection'), TransactionType.collection);
    });

    test('fromString parses disbursement', () {
      expect(TransactionType.fromString('disbursement'), TransactionType.disbursement);
    });

    test('fromString throws on unknown value', () {
      expect(() => TransactionType.fromString('unknown'), throwsArgumentError);
    });
  });

  group('FeeModel', () {
    test('fromString parses all values', () {
      expect(FeeModel.fromString('percentage'), FeeModel.percentage);
      expect(FeeModel.fromString('flat'), FeeModel.flat);
      expect(FeeModel.fromString('percentage_plus_flat'), FeeModel.percentagePlusFlat);
    });

    test('toJson returns correct strings', () {
      expect(FeeModel.percentage.toJson(), 'percentage');
      expect(FeeModel.flat.toJson(), 'flat');
      expect(FeeModel.percentagePlusFlat.toJson(), 'percentage_plus_flat');
    });

    test('fromString throws on unknown value', () {
      expect(() => FeeModel.fromString('unknown'), throwsArgumentError);
    });
  });

  group('PaymentRequestType', () {
    test('fromString parses all values', () {
      expect(PaymentRequestType.fromString('one_time'), PaymentRequestType.oneTime);
      expect(PaymentRequestType.fromString('recurring'), PaymentRequestType.recurring);
      expect(PaymentRequestType.fromString('open_amount'), PaymentRequestType.openAmount);
    });

    test('toJson returns correct strings', () {
      expect(PaymentRequestType.oneTime.toJson(), 'one_time');
      expect(PaymentRequestType.recurring.toJson(), 'recurring');
      expect(PaymentRequestType.openAmount.toJson(), 'open_amount');
    });

    test('fromString throws on unknown value', () {
      expect(() => PaymentRequestType.fromString('bad'), throwsArgumentError);
    });
  });

  group('PaymentRequestStatus', () {
    test('fromString parses all values', () {
      expect(PaymentRequestStatus.fromString('active'), PaymentRequestStatus.active);
      expect(PaymentRequestStatus.fromString('completed'), PaymentRequestStatus.completed);
      expect(PaymentRequestStatus.fromString('expired'), PaymentRequestStatus.expired);
      expect(PaymentRequestStatus.fromString('cancelled'), PaymentRequestStatus.cancelled);
    });

    test('fromString throws on unknown value', () {
      expect(() => PaymentRequestStatus.fromString('bad'), throwsArgumentError);
    });
  });

  group('TransactionStatus', () {
    test('fromString parses all values', () {
      expect(TransactionStatus.fromString('pending'), TransactionStatus.pending);
      expect(TransactionStatus.fromString('processing'), TransactionStatus.processing);
      expect(TransactionStatus.fromString('completed'), TransactionStatus.completed);
      expect(TransactionStatus.fromString('failed'), TransactionStatus.failed);
      expect(TransactionStatus.fromString('refunded'), TransactionStatus.refunded);
    });

    test('fromString throws on unknown value', () {
      expect(() => TransactionStatus.fromString('bad'), throwsArgumentError);
    });
  });

  group('FeeConfig', () {
    test('fromJson parses all fields', () {
      final json = {
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

      final config = FeeConfig.fromJson(json);
      expect(config.id, 'fee_1');
      expect(config.businessId, 'biz_1');
      expect(config.transactionType, TransactionType.collection);
      expect(config.feeModel, FeeModel.percentage);
      expect(config.percentageRate, '2.5');
      expect(config.flatAmount, '0');
      expect(config.minFee, '100');
      expect(config.maxFee, '5000');
      expect(config.currency, 'RWF');
      expect(config.isActive, isTrue);
      expect(config.createdAt, '2026-01-01T00:00:00Z');
      expect(config.updatedAt, '2026-01-02T00:00:00Z');
    });
  });

  group('PaymentRequest', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'pr_1',
        'business_id': 'biz_1',
        'wallet_id': 'wal_1',
        'request_type': 'one_time',
        'short_code': 'ABC123',
        'amount': '5000',
        'currency': 'RWF',
        'description': 'Test payment',
        'customer_phone': '+250781234567',
        'customer_name': 'John Doe',
        'status': 'active',
        'qr_data': 'qr_encoded_data',
        'max_uses': 1,
        'use_count': 0,
        'expires_at': '2026-02-01T00:00:00Z',
        'created_at': '2026-01-01T00:00:00Z',
      };

      final pr = PaymentRequest.fromJson(json);
      expect(pr.id, 'pr_1');
      expect(pr.businessId, 'biz_1');
      expect(pr.walletId, 'wal_1');
      expect(pr.requestType, PaymentRequestType.oneTime);
      expect(pr.shortCode, 'ABC123');
      expect(pr.amount, '5000');
      expect(pr.currency, 'RWF');
      expect(pr.description, 'Test payment');
      expect(pr.customerPhone, '+250781234567');
      expect(pr.customerName, 'John Doe');
      expect(pr.status, PaymentRequestStatus.active);
      expect(pr.qrData, 'qr_encoded_data');
      expect(pr.maxUses, 1);
      expect(pr.useCount, 0);
      expect(pr.expiresAt, '2026-02-01T00:00:00Z');
      expect(pr.createdAt, '2026-01-01T00:00:00Z');
    });
  });

  group('PaymentTransaction', () {
    test('fromJson parses all fields', () {
      final json = {
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
        'azampay_reference': 'az_ref_123',
        'external_id': 'ext_123',
        'description': 'Payment for order',
        'failure_reason': '',
        'created_at': '2026-01-01T00:00:00Z',
        'confirmed_at': '2026-01-01T00:01:00Z',
      };

      final txn = PaymentTransaction.fromJson(json);
      expect(txn.id, 'txn_1');
      expect(txn.paymentRequestId, 'pr_1');
      expect(txn.businessId, 'biz_1');
      expect(txn.businessWalletId, 'wal_1');
      expect(txn.customerPhone, '+250781234567');
      expect(txn.customerName, 'Jane');
      expect(txn.amount, '10000');
      expect(txn.feeAmount, '250');
      expect(txn.netAmount, '9750');
      expect(txn.currency, 'RWF');
      expect(txn.paymentMethod, 'mtn');
      expect(txn.status, TransactionStatus.completed);
      expect(txn.azampayReference, 'az_ref_123');
      expect(txn.externalId, 'ext_123');
      expect(txn.description, 'Payment for order');
      expect(txn.failureReason, '');
      expect(txn.createdAt, '2026-01-01T00:00:00Z');
      expect(txn.confirmedAt, '2026-01-01T00:01:00Z');
    });
  });

  group('CollectionResponse', () {
    test('fromJson parses all fields', () {
      final json = {
        'transaction_id': 'txn_1',
        'status': 'pending',
        'azampay_reference': 'az_123',
        'fee_amount': '100',
        'net_amount': '4900',
        'message': 'Collection initiated',
      };

      final resp = CollectionResponse.fromJson(json);
      expect(resp.transactionId, 'txn_1');
      expect(resp.status, TransactionStatus.pending);
      expect(resp.azampayReference, 'az_123');
      expect(resp.feeAmount, '100');
      expect(resp.netAmount, '4900');
      expect(resp.message, 'Collection initiated');
    });
  });

  group('Disbursement', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'disb_1',
        'business_id': 'biz_1',
        'wallet_id': 'wal_1',
        'amount': '5000',
        'fee_amount': '500',
        'net_amount': '4500',
        'currency': 'RWF',
        'destination_type': 'mobile_money',
        'destination_ref': '+250781234567',
        'destination_name': 'John Doe',
        'status': 'processing',
        'azampay_reference': 'az_456',
        'external_id': 'ext_456',
        'description': 'Payout',
        'failure_reason': '',
        'idempotency_key': 'idem_123',
        'created_at': '2026-01-01T00:00:00Z',
        'confirmed_at': '2026-01-01T00:05:00Z',
      };

      final disb = Disbursement.fromJson(json);
      expect(disb.id, 'disb_1');
      expect(disb.businessId, 'biz_1');
      expect(disb.walletId, 'wal_1');
      expect(disb.amount, '5000');
      expect(disb.feeAmount, '500');
      expect(disb.netAmount, '4500');
      expect(disb.currency, 'RWF');
      expect(disb.destinationType, 'mobile_money');
      expect(disb.destinationRef, '+250781234567');
      expect(disb.destinationName, 'John Doe');
      expect(disb.status, TransactionStatus.processing);
      expect(disb.azampayReference, 'az_456');
      expect(disb.externalId, 'ext_456');
      expect(disb.description, 'Payout');
      expect(disb.failureReason, '');
      expect(disb.idempotencyKey, 'idem_123');
      expect(disb.createdAt, '2026-01-01T00:00:00Z');
      expect(disb.confirmedAt, '2026-01-01T00:05:00Z');
    });
  });

  group('DisbursementResponse', () {
    test('fromJson parses all fields', () {
      final json = {
        'disbursement_id': 'disb_1',
        'status': 'pending',
        'fee_amount': '500',
        'net_amount': '4500',
        'estimated_arrival': '2026-01-01T01:00:00Z',
      };

      final resp = DisbursementResponse.fromJson(json);
      expect(resp.disbursementId, 'disb_1');
      expect(resp.status, TransactionStatus.pending);
      expect(resp.feeAmount, '500');
      expect(resp.netAmount, '4500');
      expect(resp.estimatedArrival, '2026-01-01T01:00:00Z');
    });
  });

  group('CalculateFeeResult', () {
    test('fromJson parses all fields', () {
      final json = {
        'gross_amount': '10000',
        'fee_amount': '250',
        'net_amount': '9750',
        'fee_model': 'percentage',
        'percentage_rate': '2.5',
        'flat_amount': '0',
        'currency': 'RWF',
      };

      final result = CalculateFeeResult.fromJson(json);
      expect(result.grossAmount, '10000');
      expect(result.feeAmount, '250');
      expect(result.netAmount, '9750');
      expect(result.feeModel, FeeModel.percentage);
      expect(result.percentageRate, '2.5');
      expect(result.flatAmount, '0');
      expect(result.currency, 'RWF');
    });
  });

  group('SetFeeConfigParams', () {
    test('toJson includes required fields', () {
      const params = SetFeeConfigParams(
        businessId: 'biz_1',
        transactionType: TransactionType.collection,
        feeModel: FeeModel.percentage,
      );

      final json = params.toJson();
      expect(json['business_id'], 'biz_1');
      expect(json['transaction_type'], 'collection');
      expect(json['fee_model'], 'percentage');
      expect(json.containsKey('percentage_rate'), isFalse);
    });

    test('toJson includes optional fields when set', () {
      const params = SetFeeConfigParams(
        businessId: 'biz_1',
        transactionType: TransactionType.disbursement,
        feeModel: FeeModel.percentagePlusFlat,
        percentageRate: '2.5',
        flatAmount: '100',
        minFee: '50',
        maxFee: '5000',
        currency: 'RWF',
      );

      final json = params.toJson();
      expect(json['percentage_rate'], '2.5');
      expect(json['flat_amount'], '100');
      expect(json['min_fee'], '50');
      expect(json['max_fee'], '5000');
      expect(json['currency'], 'RWF');
      expect(json['fee_model'], 'percentage_plus_flat');
    });
  });

  group('CreatePaymentRequestParams', () {
    test('toJson includes required fields', () {
      const params = CreatePaymentRequestParams(
        businessId: 'biz_1',
        walletId: 'wal_1',
        requestType: PaymentRequestType.oneTime,
        amount: '5000',
      );

      final json = params.toJson();
      expect(json['business_id'], 'biz_1');
      expect(json['wallet_id'], 'wal_1');
      expect(json['request_type'], 'one_time');
      expect(json['amount'], '5000');
      expect(json.containsKey('currency'), isFalse);
    });

    test('toJson includes optional fields when set', () {
      const params = CreatePaymentRequestParams(
        businessId: 'biz_1',
        walletId: 'wal_1',
        requestType: PaymentRequestType.recurring,
        amount: '5000',
        currency: 'RWF',
        description: 'Monthly',
        customerPhone: '+250781234567',
        customerName: 'John',
        maxUses: 12,
        expiresAt: '2027-01-01T00:00:00Z',
      );

      final json = params.toJson();
      expect(json['currency'], 'RWF');
      expect(json['description'], 'Monthly');
      expect(json['customer_phone'], '+250781234567');
      expect(json['customer_name'], 'John');
      expect(json['max_uses'], 12);
      expect(json['expires_at'], '2027-01-01T00:00:00Z');
    });
  });

  group('InitiateCollectionParams', () {
    test('toJson includes required fields', () {
      const params = InitiateCollectionParams(
        businessId: 'biz_1',
        walletId: 'wal_1',
        customerPhone: '+250781234567',
        amount: '5000',
        paymentMethod: 'mtn',
      );

      final json = params.toJson();
      expect(json['business_id'], 'biz_1');
      expect(json['wallet_id'], 'wal_1');
      expect(json['customer_phone'], '+250781234567');
      expect(json['amount'], '5000');
      expect(json['payment_method'], 'mtn');
    });

    test('toJson includes optional fields when set', () {
      const params = InitiateCollectionParams(
        businessId: 'biz_1',
        walletId: 'wal_1',
        customerPhone: '+250781234567',
        amount: '5000',
        paymentMethod: 'mtn',
        currency: 'RWF',
        description: 'Order #123',
        externalId: 'ext_1',
      );

      final json = params.toJson();
      expect(json['currency'], 'RWF');
      expect(json['description'], 'Order #123');
      expect(json['external_id'], 'ext_1');
    });
  });

  group('InitiateDisbursementParams', () {
    test('toJson includes required fields', () {
      const params = InitiateDisbursementParams(
        businessId: 'biz_1',
        walletId: 'wal_1',
        amount: '5000',
        destinationType: 'mobile_money',
        destinationRef: '+250781234567',
        idempotencyKey: 'idem_1',
      );

      final json = params.toJson();
      expect(json['business_id'], 'biz_1');
      expect(json['wallet_id'], 'wal_1');
      expect(json['amount'], '5000');
      expect(json['destination_type'], 'mobile_money');
      expect(json['destination_ref'], '+250781234567');
      expect(json['idempotency_key'], 'idem_1');
      expect(json.containsKey('destination_name'), isFalse);
    });

    test('toJson includes optional fields when set', () {
      const params = InitiateDisbursementParams(
        businessId: 'biz_1',
        walletId: 'wal_1',
        amount: '5000',
        destinationType: 'mobile_money',
        destinationRef: '+250781234567',
        destinationName: 'John Doe',
        currency: 'RWF',
        description: 'Payout',
        idempotencyKey: 'idem_1',
      );

      final json = params.toJson();
      expect(json['destination_name'], 'John Doe');
      expect(json['currency'], 'RWF');
      expect(json['description'], 'Payout');
    });
  });

  group('CalculateFeeParams', () {
    test('toJson includes required fields', () {
      const params = CalculateFeeParams(
        businessId: 'biz_1',
        amount: '10000',
        transactionType: TransactionType.collection,
      );

      final json = params.toJson();
      expect(json['business_id'], 'biz_1');
      expect(json['amount'], '10000');
      expect(json['transaction_type'], 'collection');
      expect(json.containsKey('currency'), isFalse);
    });

    test('toJson includes currency when set', () {
      const params = CalculateFeeParams(
        businessId: 'biz_1',
        amount: '10000',
        transactionType: TransactionType.disbursement,
        currency: 'RWF',
      );

      final json = params.toJson();
      expect(json['currency'], 'RWF');
    });
  });
}
