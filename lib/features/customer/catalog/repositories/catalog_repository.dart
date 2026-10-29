import 'package:jsmu/core/errors/failure.dart';
import 'package:jsmu/core/logger/app_logger.dart';

import '../models/service_item_model.dart';
import '../services/catalog_service.dart';

class CatalogRepository {
  final CatalogService _catalogService;

  CatalogRepository({CatalogService? catalogService})
    : _catalogService = catalogService ?? CatalogService();

  Future<List<ServiceItemModel>> getAcServices() async {
    try {
      return await _catalogService.fetchAcServices();
    } catch (e) {
      AppLogger.error('CatalogRepository getAcServices error: $e');
      throw Failure(e.toString());
    }
  }
}
