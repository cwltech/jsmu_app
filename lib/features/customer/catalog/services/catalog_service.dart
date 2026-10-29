import 'package:jsmu/core/constants/app_api_endpoints.dart';
import 'package:jsmu/core/constants/app_config.dart';
import 'package:jsmu/core/network/api_client.dart';
import 'package:jsmu/core/network/mock_data.dart';

import '../models/service_item_model.dart';

class CatalogService {
  final ApiClient _apiClient;

  CatalogService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<ServiceItemModel>> fetchAcServices() async {
    try {
      final res = await _apiClient.get(
        '${AppApiEndpoints.serviceDetails}ac',
        fromJson: (json) => (json as List)
            .map(
              (item) => ServiceItemModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
      return res.data ?? [];
    } catch (_) {
      if (AppConfig.useMockBackendFallback) {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.acServices
            .map((item) => ServiceItemModel.fromJson(item))
            .toList();
      }
      rethrow;
    }
  }
}
