import 'package:wistfare_core/wistfare_core.dart';

import 'types.dart';

/// Wistfare Business client — read-only access to businesses.
class BusinessClient {
  final Wistfare _client;

  BusinessClient(this._client);

  /// Get a business by ID.
  Future<Business> get(String businessId) async {
    final json = await _client.get('/v1/businesses/$businessId');
    return Business.fromJson(json!);
  }

  /// List businesses, optionally filtered by business ID.
  Future<ListResponse<Business>> list({String? businessId, int? page, int? perPage}) async {
    final json = await _client.get('/v1/businesses', query: {
      if (businessId != null) 'business_id': businessId,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    });
    return ListResponse.fromJson(json!, Business.fromJson);
  }
}
