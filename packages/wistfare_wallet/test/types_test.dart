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

  group('Balance', () {
    test('fromJson parses all fields', () {
      final json = {
        'wallet_id': 'wal_1',
        'available_balance': '45000',
        'pending_balance': '5000',
        'currency': 'RWF',
        'as_of': '2026-01-15T12:00:00Z',
      };

      final balance = Balance.fromJson(json);
      expect(balance.walletId, 'wal_1');
      expect(balance.availableBalance, '45000');
      expect(balance.pendingBalance, '5000');
      expect(balance.currency, 'RWF');
      expect(balance.asOf, '2026-01-15T12:00:00Z');
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

  group('TransactionEntry', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'entry_1',
        'transaction_type': 'transfer',
        'from_wallet_id': 'wal_1',
        'to_wallet_id': 'wal_2',
        'amount': '10000',
        'fee': '100',
        'currency': 'RWF',
        'status': 'completed',
        'entry_hash': 'abc123hash',
        'description': 'Transfer to friend',
        'created_at': '2026-01-01T00:00:00Z',
        'confirmed_at': '2026-01-01T00:01:00Z',
      };

      final entry = TransactionEntry.fromJson(json);
      expect(entry.id, 'entry_1');
      expect(entry.transactionType, 'transfer');
      expect(entry.fromWalletId, 'wal_1');
      expect(entry.toWalletId, 'wal_2');
      expect(entry.amount, '10000');
      expect(entry.fee, '100');
      expect(entry.currency, 'RWF');
      expect(entry.status, 'completed');
      expect(entry.entryHash, 'abc123hash');
      expect(entry.description, 'Transfer to friend');
      expect(entry.createdAt, '2026-01-01T00:00:00Z');
      expect(entry.confirmedAt, '2026-01-01T00:01:00Z');
    });
  });

  group('DepositResult', () {
    test('fromJson parses all fields', () {
      final json = {
        'deposit_id': 'dep_1',
        'status': 'pending',
        'payment_url': 'https://pay.example.com/dep_1',
        'instructions': 'Dial *182# to confirm',
      };

      final result = DepositResult.fromJson(json);
      expect(result.depositId, 'dep_1');
      expect(result.status, 'pending');
      expect(result.paymentUrl, 'https://pay.example.com/dep_1');
      expect(result.instructions, 'Dial *182# to confirm');
    });
  });

  group('WithdrawalResult', () {
    test('fromJson parses all fields', () {
      final json = {
        'withdrawal_id': 'wd_1',
        'status': 'processing',
        'estimated_arrival': '2026-01-01T01:00:00Z',
      };

      final result = WithdrawalResult.fromJson(json);
      expect(result.withdrawalId, 'wd_1');
      expect(result.status, 'processing');
      expect(result.estimatedArrival, '2026-01-01T01:00:00Z');
    });
  });

  group('WalletRole', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'role_1',
        'wallet_id': 'wal_1',
        'name': 'Viewer',
        'permissions': ['view_balance', 'view_transactions'],
        'is_system': false,
        'created_by': 'usr_1',
        'created_at': '2026-01-01T00:00:00Z',
      };

      final role = WalletRole.fromJson(json);
      expect(role.id, 'role_1');
      expect(role.walletId, 'wal_1');
      expect(role.name, 'Viewer');
      expect(role.permissions, ['view_balance', 'view_transactions']);
      expect(role.isSystem, isFalse);
      expect(role.createdBy, 'usr_1');
      expect(role.createdAt, '2026-01-01T00:00:00Z');
    });
  });

  group('WalletMember', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'mem_1',
        'wallet_id': 'wal_1',
        'user_id': 'usr_2',
        'role_id': 'role_1',
        'role_name': 'Viewer',
        'permissions': ['view_balance'],
        'granted_by': 'usr_1',
        'created_at': '2026-01-01T00:00:00Z',
      };

      final member = WalletMember.fromJson(json);
      expect(member.id, 'mem_1');
      expect(member.walletId, 'wal_1');
      expect(member.userId, 'usr_2');
      expect(member.roleId, 'role_1');
      expect(member.roleName, 'Viewer');
      expect(member.permissions, ['view_balance']);
      expect(member.grantedBy, 'usr_1');
      expect(member.createdAt, '2026-01-01T00:00:00Z');
    });
  });

  group('CreateWalletParams', () {
    test('toJson includes required fields', () {
      const params = CreateWalletParams(userId: 'usr_1', walletType: WalletType.personal);
      final json = params.toJson();
      expect(json['user_id'], 'usr_1');
      expect(json['wallet_type'], 'personal');
      expect(json.containsKey('currency'), isFalse);
    });

    test('toJson includes currency when set', () {
      const params = CreateWalletParams(userId: 'usr_1', walletType: WalletType.business, currency: 'RWF');
      expect(params.toJson()['currency'], 'RWF');
    });
  });

  group('TransferParams', () {
    test('toJson includes required fields', () {
      const params = TransferParams(
        fromWalletId: 'wal_1',
        toWalletId: 'wal_2',
        amount: '10000',
        idempotencyKey: 'idem_1',
      );
      final json = params.toJson();
      expect(json['from_wallet_id'], 'wal_1');
      expect(json['to_wallet_id'], 'wal_2');
      expect(json['amount'], '10000');
      expect(json['idempotency_key'], 'idem_1');
      expect(json.containsKey('description'), isFalse);
    });

    test('toJson includes description when set', () {
      const params = TransferParams(
        fromWalletId: 'wal_1',
        toWalletId: 'wal_2',
        amount: '10000',
        description: 'Rent',
        idempotencyKey: 'idem_1',
      );
      expect(params.toJson()['description'], 'Rent');
    });
  });

  group('InitiateDepositParams', () {
    test('toJson includes required fields', () {
      const params = InitiateDepositParams(
        walletId: 'wal_1',
        amount: '5000',
        paymentMethod: 'mtn',
        phoneNumber: '+250781234567',
      );
      final json = params.toJson();
      expect(json['wallet_id'], 'wal_1');
      expect(json['amount'], '5000');
      expect(json['payment_method'], 'mtn');
      expect(json['phone_number'], '+250781234567');
      expect(json.containsKey('currency'), isFalse);
    });
  });

  group('InitiateWithdrawalParams', () {
    test('toJson includes required fields', () {
      const params = InitiateWithdrawalParams(
        walletId: 'wal_1',
        amount: '5000',
        destinationType: 'mobile_money',
        destinationRef: '+250781234567',
      );
      final json = params.toJson();
      expect(json['wallet_id'], 'wal_1');
      expect(json['amount'], '5000');
      expect(json['destination_type'], 'mobile_money');
      expect(json['destination_ref'], '+250781234567');
    });
  });

  group('CreateWalletRoleParams', () {
    test('toJson includes all fields', () {
      const params = CreateWalletRoleParams(
        walletId: 'wal_1',
        name: 'Viewer',
        permissions: ['view_balance', 'view_transactions'],
      );
      final json = params.toJson();
      expect(json['wallet_id'], 'wal_1');
      expect(json['name'], 'Viewer');
      expect(json['permissions'], ['view_balance', 'view_transactions']);
    });
  });

  group('AddWalletMemberParams', () {
    test('toJson includes all fields', () {
      const params = AddWalletMemberParams(
        walletId: 'wal_1',
        userId: 'usr_2',
        roleId: 'role_1',
      );
      final json = params.toJson();
      expect(json['wallet_id'], 'wal_1');
      expect(json['user_id'], 'usr_2');
      expect(json['role_id'], 'role_1');
    });
  });
}
