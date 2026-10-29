import 'package:jsmu/core/errors/failure.dart';
import 'package:jsmu/core/logger/app_logger.dart';

import '../models/tracking_status_model.dart';
import '../services/tracking_service.dart';

class TrackingRepository {
  final TrackingService _trackingService;

  TrackingRepository({TrackingService? trackingService})
    : _trackingService = trackingService ?? TrackingService();

  Future<TrackingStatusModel> getLiveStatus(String bookingId) async {
    try {
      return await _trackingService.fetchLiveTracking(bookingId);
    } catch (e) {
      AppLogger.error('TrackingRepository getLiveStatus error: $e');
      throw Failure(e.toString());
    }
  }
}
