import 'package:jsmu/core/errors/failure.dart';
import 'package:jsmu/core/logger/app_logger.dart';

import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingRepository {
  final BookingService _bookingService;

  BookingRepository({BookingService? bookingService})
    : _bookingService = bookingService ?? BookingService();

  Future<BookingModel> placeBooking(Map<String, dynamic> bookingData) async {
    try {
      return await _bookingService.createBooking(bookingData);
    } catch (e) {
      AppLogger.error('BookingRepository placeBooking error: $e');
      throw Failure(e.toString());
    }
  }
}
