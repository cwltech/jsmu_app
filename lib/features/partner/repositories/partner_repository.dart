import 'package:jsmu/core/errors/failure.dart';
import 'package:jsmu/core/logger/app_logger.dart';

import '../models/dispatch_lead_model.dart';
import '../models/partner_dashboard_model.dart';
import '../models/partner_wallet_model.dart';
import '../services/partner_service.dart';

class PartnerRepository {
  final PartnerService _partnerService;

  PartnerRepository({PartnerService? partnerService})
    : _partnerService = partnerService ?? PartnerService();

  Future<DispatchLeadModel> getDispatchLead() async {
    try {
      return await _partnerService.fetchInstantDispatchLead();
    } catch (e) {
      AppLogger.error('PartnerRepository getDispatchLead error: $e');
      throw Failure(e.toString());
    }
  }

  Future<PartnerDashboardModel> getDashboard() async {
    try {
      return await _partnerService.fetchDashboard();
    } catch (e) {
      AppLogger.error('PartnerRepository getDashboard error: $e');
      throw Failure(e.toString());
    }
  }

  Future<PartnerWalletModel> getWallet() async {
    try {
      return await _partnerService.fetchWallet();
    } catch (e) {
      AppLogger.error('PartnerRepository getWallet error: $e');
      throw Failure(e.toString());
    }
  }
}
