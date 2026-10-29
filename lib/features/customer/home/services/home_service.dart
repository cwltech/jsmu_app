import 'package:jsmu/core/constants/app_api_endpoints.dart';
import 'package:jsmu/core/constants/app_config.dart';
import 'package:jsmu/core/network/api_client.dart';
import 'package:jsmu/core/network/mock_data.dart';

import '../models/popular_service.dart';
import '../models/service_category.dart';

class HomeService {
  final ApiClient _apiClient;

  HomeService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<ServiceCategory>> fetchCategories() async {
    try {
      final res = await _apiClient.get(
        AppApiEndpoints.categories,
        fromJson: (json) => (json as List)
            .map(
              (item) => ServiceCategory.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
      return res.data ?? [];
    } catch (_) {
      if (AppConfig.useMockBackendFallback) {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.categories
            .map((item) => ServiceCategory.fromJson(item))
            .toList();
      }
      rethrow;
    }
  }

  Future<List<PopularService>> fetchPopularServices() async {
    try {
      final res = await _apiClient.get(
        AppApiEndpoints.popularServices,
        fromJson: (json) => (json as List)
            .map(
              (item) => PopularService.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
      return res.data ?? [];
    } catch (_) {
      if (AppConfig.useMockBackendFallback) {
        await Future.delayed(const Duration(milliseconds: 400));
        return MockData.popularServices
            .map((item) => PopularService.fromJson(item))
            .toList();
      }
      rethrow;
    }
  }
}
