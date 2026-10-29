import 'package:jsmu/core/errors/failure.dart';
import 'package:jsmu/core/logger/app_logger.dart';

import '../models/popular_service.dart';
import '../models/service_category.dart';
import '../services/home_service.dart';

class HomeRepository {
  final HomeService _homeService;

  HomeRepository({HomeService? homeService})
    : _homeService = homeService ?? HomeService();

  Future<List<ServiceCategory>> getCategories() async {
    try {
      return await _homeService.fetchCategories();
    } catch (e) {
      AppLogger.error('HomeRepository getCategories error: $e');
      throw Failure(e.toString());
    }
  }

  Future<List<PopularService>> getPopularServices() async {
    try {
      return await _homeService.fetchPopularServices();
    } catch (e) {
      AppLogger.error('HomeRepository getPopularServices error: $e');
      throw Failure(e.toString());
    }
  }
}
