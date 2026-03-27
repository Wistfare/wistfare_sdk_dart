import 'package:test/test.dart';
import 'package:wistfare_wallet/wistfare_wallet.dart';

void main() {
  group('WalletType', () {
    test('fromString parses all values', () {
      expect(WalletType.fromString('personal'), WalletType.personal);
      expect(WalletType.fromString('business'), WalletType.business);
    });

    test('fromString throws on unknown value', () {
      expect(() => WalletType.fromString('unknown'), throwsArgumentError);
    });
  });

  group('WalletState', () {
    test('fromString parses all values', () {
      expect(WalletState.fromString('active'), WalletState.active);
      expect(WalletState.fromString('suspended'), WalletState.suspended);
      expect(WalletState.fromString('closed'), WalletState.closed);
    });

    test('fromString throws on unknown value', () {
      expect(() => WalletState.fromString('unknown'), throwsArgumentError);
    });
  });

  group('Wallet', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'wal_1',
        'user_id': 'usr_1',
        'wallet_type': 'personal',
        'kyc_tier': 'tier_1',
        'state': 'active',
        'balance': '50000',
        'currency': 'RWF',
        'azampay_linked': true,
        'created_at': '2026-01-01T00:00:00Z',
      };

      final wallet = Wallet.fromJson(json);
      expect(wallet.id, 'wal_1');
      expect(wallet.userId, 'usr_1');
      expect(wallet.walletType, WalletType.personal);
      expect(wallet.kycTier, 'tier_1');
      expect(wallet.state, WalletState.active);
      expect(wallet.balance, '50000');
      expect(wallet.currency, 'RWF');
      expect(wallet.azampayLinked, isTrue);
      expect(wallet.createdAt, '2026-01-01T00:00:00Z');
    });
  });

  group('TransferResult', () {
    test('fromJson parses all fields', () {
      final json = {
        'transaction_id': 'txn_1',
        'status': 'completed',
        'from_balance': '45000',
        'to_balance': '55000',
        'amount': '10000',
        'fee': '100',
        'currency': 'RWF',
        'created_at': '2026-01-01T00:00:00Z',
      };

      final result = TransferResult.fromJson(json);
      expect(result.transactionId, 'txn_1');
      expect(result.status, 'completed');
      expect(result.fromBalance, '45000');
      expect(result.toBalance, '55000');
      expect(result.amount, '10000');
      expect(result.fee, '100');
      expect(result.currency, 'RWF');
      expect(result.createdAt, '2026-01-01T00:00:00Z');
    });
  });

  group('TransferParams', () {
    test('toJson includes required fields', () {
      const params = TransferParams(
        fromWalletId: 'wal_1',
        toWalletId: 'wal_2',
        amount: '10000',
        referenceId: 'idem_1',
      );
      final json = params.toJson();
      expect(json['from_wallet_id'], 'wal_1');
      expect(json['to_wallet_id'], 'wal_2');
      expect(json['amount'], '10000');
      expect(json['reference_id'], 'idem_1');
      expect(json.containsKey('description'), isFalse);
    });

    test('toJson includes description when set', () {
      const params = TransferParams(
        fromWalletId: 'wal_1',
        toWalletId: 'wal_2',
        amount: '10000',
        description: 'Rent',
        referenceId: 'idem_1',
      );
      expect(params.toJson()['description'], 'Rent');
    });
  });
}
