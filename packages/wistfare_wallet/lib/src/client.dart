import 'package:wistfare_core/wistfare_core.dart';

import 'types.dart';

/// Wistfare Wallet client — retrieve wallets and transfer funds.
class WalletClient {
  final Wistfare _client;

  WalletClient(this._client);

  /// Get a wallet by wallet ID or owner ID (query params).
  Future<Wallet> get({String? walletId, String? ownerId}) async {
    final json = await _client.get('/v1/wallets', query: {
      if (walletId != null) 'wallet_id': walletId,
      if (ownerId != null) 'owner_id': ownerId,
    });
    return Wallet.fromJson(json!);
  }

  /// Transfer funds between wallets.
  Future<TransferResult> transfer(TransferParams params) async {
    final json = await _client.post('/v1/wallets/transfers', body: params.toJson());
    return TransferResult.fromJson(json!);
  }
}
