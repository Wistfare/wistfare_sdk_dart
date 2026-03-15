# Wistfare Dart / Flutter SDK

Official Dart SDK for the [Wistfare](https://wistfare.com) API. Build payments, wallets, and business management into your Flutter or Dart application.

## Installation

Add only the packages you need to your `pubspec.yaml`:

```yaml
dependencies:
  wistfare_core: ^0.1.0
  wistfare_payments: ^0.1.0
  wistfare_wallet: ^0.1.0
  wistfare_business: ^0.1.0
```

| Package | Description |
|---------|-------------|
| `wistfare_core` | HTTP client, authentication, error handling, pagination |
| `wistfare_payments` | Collections, disbursements, fee management, payment requests |
| `wistfare_wallet` | Balances, transfers, deposits, withdrawals, wallet members |
| `wistfare_business` | Business management, staff, teams, API keys |

## Quick Start

```dart
import 'package:wistfare_core/wistfare_core.dart';
import 'package:wistfare_payments/wistfare_payments.dart';

final wf = Wistfare(apiKey: 'wf_live_xxx');
final payments = PaymentsClient(wf);

// Collect a payment via MTN Mobile Money
final collection = await payments.initiateCollection(InitiateCollectionParams(
  businessId: 'biz_123',
  walletId: 'wal_456',
  customerPhone: '250788000000',
  amount: '10000',
  paymentMethod: 'mtn',
  currency: 'RWF',
  description: 'Invoice #1234',
));

print('${collection.transactionId} ${collection.status}');
```

## Configuration

```dart
final wf = Wistfare(
  apiKey: 'wf_live_xxx',                        // Required — wf_live_* or wf_test_*
  baseUrl: 'https://api.wistfare.com',           // Optional
  timeout: Duration(seconds: 30),                // Optional (default: 30s)
  maxRetries: 2,                                 // Optional — retries on 5xx/network errors
);
```

### Test Mode

Use a `wf_test_*` API key for sandbox testing. Check with `wf.isTestMode`.

### Closing the Client

```dart
// When done, close the HTTP client
wf.close();
```

## Payments

```dart
import 'package:wistfare_payments/wistfare_payments.dart';

final payments = PaymentsClient(wf);

// Initiate a mobile money collection
final result = await payments.initiateCollection(InitiateCollectionParams(
  businessId: 'biz_123',
  walletId: 'wal_456',
  customerPhone: '250788000000',
  amount: '5000',
  paymentMethod: 'mtn',  // 'mtn' or 'airtel_Rw'
  currency: 'RWF',
));

// Create a payment request (QR code / payment link)
final paymentRequest = await payments.createPaymentRequest(CreatePaymentRequestParams(
  businessId: 'biz_123',
  walletId: 'wal_456',
  requestType: PaymentRequestType.oneTime,
  amount: '5000',
  currency: 'RWF',
  description: 'Table 4 — Lunch',
));
print(paymentRequest.shortCode); // "PAY-A1B2C3"
print(paymentRequest.qrData);    // QR data string

// Calculate fees
final fee = await payments.calculateFee(CalculateFeeParams(
  businessId: 'biz_123',
  amount: '10000',
  transactionType: TransactionType.collection,
));
print(fee.feeAmount);  // "250"
print(fee.netAmount);  // "9750"

// Initiate a disbursement (payout)
final payout = await payments.initiateDisbursement(InitiateDisbursementParams(
  businessId: 'biz_123',
  walletId: 'wal_456',
  amount: '5000',
  destinationType: 'mobile_money',
  destinationRef: '250788000000',
  idempotencyKey: 'disb_unique_123',
));

// List transactions
final txns = await payments.listTransactions('biz_123', page: 1, perPage: 20);
```

### All Payments Methods

| Method | Description |
|--------|-------------|
| `setFeeConfig(params)` | Configure fees for a business |
| `getFeeConfig(businessId, transactionType)` | Get fee configuration |
| `listFeeConfigs(businessId)` | List all fee configs |
| `deleteFeeConfig(feeConfigId)` | Delete a fee config |
| `calculateFee(params)` | Calculate fee for an amount |
| `createPaymentRequest(params)` | Create a QR / payment link |
| `getPaymentRequest(requestId)` | Get a payment request |
| `listPaymentRequests(businessId)` | List payment requests |
| `cancelPaymentRequest(requestId)` | Cancel a payment request |
| `initiateCollection(params)` | Charge a customer via mobile money |
| `getTransaction(transactionId)` | Get a transaction |
| `listTransactions(businessId)` | List transactions |
| `initiateDisbursement(params)` | Payout to mobile money |
| `getDisbursement(disbursementId)` | Get a disbursement |
| `listDisbursements(businessId)` | List disbursements |

## Wallet

```dart
import 'package:wistfare_wallet/wistfare_wallet.dart';

final wallet = WalletClient(wf);

// Create a wallet
final w = await wallet.create(CreateWalletParams(
  userId: 'usr_123',
  walletType: WalletType.personal,
));

// Check balance
final balance = await wallet.getBalance('wal_456');
print('${balance.availableBalance} ${balance.currency}'); // "15000 RWF"

// Transfer between wallets
final transfer = await wallet.transfer(TransferParams(
  fromWalletId: 'wal_456',
  toWalletId: 'wal_789',
  amount: '5000',
  description: 'Split dinner',
  idempotencyKey: 'txn_unique_123',
));

// Deposit (fund wallet via mobile money)
final deposit = await wallet.initiateDeposit(InitiateDepositParams(
  walletId: 'wal_456',
  amount: '10000',
  paymentMethod: 'mtn',
  phoneNumber: '250788000000',
));

// Withdraw (cash out to mobile money)
final withdrawal = await wallet.initiateWithdrawal(InitiateWithdrawalParams(
  walletId: 'wal_456',
  amount: '5000',
  destinationType: 'mobile_money',
  destinationRef: '250788000000',
));
```

### Shared Wallet RBAC

```dart
// Create a role
final role = await wallet.createRole(CreateWalletRoleParams(
  walletId: 'wal_456',
  name: 'viewer',
  permissions: ['balance:read', 'transactions:read'],
));

// Add a member
await wallet.addMember(AddWalletMemberParams(
  walletId: 'wal_456',
  userId: 'usr_789',
  roleId: role.id,
));

// List members
final members = await wallet.listMembers('wal_456');
```

## Business

```dart
import 'package:wistfare_business/wistfare_business.dart';

final business = BusinessClient(wf);

// Create a business
final biz = await business.create(CreateBusinessParams(
  name: 'Kigali Coffee House',
  businessType: 'restaurant',
  category: 'food_beverage',
));

// Invite staff
final invitation = await business.inviteStaff(InviteStaffParams(
  businessId: biz.id,
  email: 'manager@example.com',
  role: 'manager',
));

// Create a team
final team = await business.createTeam(CreateTeamParams(
  businessId: biz.id,
  name: 'Kitchen Staff',
));

// Create an API key
final apiKey = await business.createAPIKey(CreateAPIKeyParams(
  businessId: biz.id,
  name: 'Production Key',
  environment: 'live',
));
print(apiKey.rawKey); // Only shown once!
```

## Error Handling

All SDK errors extend `WistfareException`:

```dart
import 'package:wistfare_core/wistfare_core.dart';

try {
  await payments.getTransaction('txn_nonexistent');
} on NotFoundException {
  print('Transaction not found');
} on AuthenticationException {
  print('Bad API key');
} on WistfareException catch (e) {
  print('${e.message} ${e.statusCode} ${e.code} ${e.requestId}');
}
```

| Exception Class | HTTP Status | Code |
|-----------------|-------------|------|
| `AuthenticationException` | 401 | `authentication_error` |
| `PermissionException` | 403 | `permission_error` |
| `NotFoundException` | 404 | `not_found` |
| `ValidationException` | 400/422 | `validation_error` |
| `RateLimitException` | 429 | `rate_limit` |

## Pagination

List methods return a `ListResponse<T>` with pagination fields:

```dart
final result = await payments.listTransactions('biz_123', page: 1, perPage: 20);

print(result.data);    // List<PaymentTransaction>
print(result.total);   // Total count
print(result.page);    // Current page
print(result.perPage); // Items per page
print(result.hasMore); // More pages available?
```

## Monorepo Structure

This SDK uses [Melos](https://melos.invertase.dev/) to manage the multi-package monorepo:

```
packages/
  wistfare_core/       # Shared HTTP client and types
  wistfare_payments/   # Payments API
  wistfare_wallet/     # Wallet API
  wistfare_business/   # Business API
```

## Requirements

- Dart SDK 3.5+
- Flutter 3.22+ (if using with Flutter)

## Development

```bash
# Install Melos globally
dart pub global activate melos

# Bootstrap all packages
melos bootstrap

# Run all tests
melos run test

# Or test individual packages
cd packages/wistfare_core && dart test
```

## License

MIT
