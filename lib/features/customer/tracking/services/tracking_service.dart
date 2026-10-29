import 'package:jsmu/core/constants/app_api_endpoints.dart';
import 'package:jsmu/core/constants/app_config.dart';
import 'package:jsmu/core/network/api_client.dart';
import 'package:jsmu/core/network/mock_data.dart';

import '../models/tracking_status_model.dart';

class TrackingService {
  final ApiClient _apiClient;

  TrackingService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<TrackingStatusModel> fetchLiveTracking(String bookingId) async {
    try {
      final res = await _apiClient.get(
        '${AppApiEndpoints.activeTracking}$bookingId',
        fromJson: (json) =>
            TrackingStatusModel.fromJson(json as Map<String, dynamic>),
      );
      return res.data ?? TrackingStatusModel.fromJson(MockData.activeTracking);
    } catch (_) {
      if (AppConfig.useMockBackendFallback) {
        await Future.delayed(const Duration(milliseconds: 300));
        return TrackingStatusModel.fromJson(MockData.activeTracking);
      }
      rethrow;
    }
  }
}
