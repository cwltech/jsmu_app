import 'package:jsmu/core/constants/app_api_endpoints.dart';
import 'package:jsmu/core/constants/app_config.dart';
import 'package:jsmu/core/network/api_client.dart';

import '../models/booking_model.dart';

class BookingService {
  final ApiClient _apiClient;

  BookingService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final res = await _apiClient.post(
        AppApiEndpoints.createBooking,
        body: bookingData,
        fromJson: (json) => BookingModel.fromJson(json as Map<String, dynamic>),
      );
      return res.data ?? BookingModel.fromJson(bookingData);
    } catch (_) {
      if (AppConfig.useMockBackendFallback) {
        await Future.delayed(const Duration(milliseconds: 600));
        return BookingModel.fromJson(bookingData);
      }
      rethrow;
    }
  }
}
