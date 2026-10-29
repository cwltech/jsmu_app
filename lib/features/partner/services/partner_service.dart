import 'package:jsmu/core/constants/app_api_endpoints.dart';
import 'package:jsmu/core/constants/app_config.dart';
import 'package:jsmu/core/network/api_client.dart';
import 'package:jsmu/core/network/mock_data.dart';

import '../models/dispatch_lead_model.dart';
import '../models/partner_dashboard_model.dart';
import '../models/partner_wallet_model.dart';

class PartnerService {
  final ApiClient _apiClient;

  PartnerService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<DispatchLeadModel> fetchInstantDispatchLead() async {
    try {
      final res = await _apiClient.get(
        '/partner/leads/instant',
        fromJson: (json) =>
            DispatchLeadModel.fromJson(json as Map<String, dynamic>),
      );
      return res.data ?? DispatchLeadModel.fromJson(MockData.partnerDispatch);
    } catch (_) {
      if (AppConfig.useMockBackendFallback) {
        await Future.delayed(const Duration(milliseconds: 300));
        return DispatchLeadModel.fromJson(MockData.partnerDispatch);
      }
      rethrow;
    }
  }

  Future<PartnerDashboardModel> fetchDashboard() async {
    try {
      final res = await _apiClient.get(
        AppApiEndpoints.partnerMetrics,
        fromJson: (json) =>
            PartnerDashboardModel.fromJson(json as Map<String, dynamic>),
      );
      return res.data ??
          PartnerDashboardModel.fromJson(MockData.partnerDashboard);
    } catch (_) {
      if (AppConfig.useMockBackendFallback) {
        await Future.delayed(const Duration(milliseconds: 400));
        return PartnerDashboardModel.fromJson(MockData.partnerDashboard);
      }
      rethrow;
    }
  }

  Future<PartnerWalletModel> fetchWallet() async {
    try {
      final res = await _apiClient.get(
        AppApiEndpoints.partnerWallet,
        fromJson: (json) =>
            PartnerWalletModel.fromJson(json as Map<String, dynamic>),
      );
      return res.data ?? PartnerWalletModel.fromJson(MockData.partnerWallet);
    } catch (_) {
      if (AppConfig.useMockBackendFallback) {
        await Future.delayed(const Duration(milliseconds: 400));
        return PartnerWalletModel.fromJson(MockData.partnerWallet);
      }
      rethrow;
    }
  }
}
