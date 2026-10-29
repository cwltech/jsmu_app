import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jsmu/core/constants/app_colors.dart';
import 'package:jsmu/core/constants/app_sizes.dart';
import 'package:jsmu/core/theme/app_text_styles.dart';
import 'package:jsmu/core/utils/formatters.dart';
import 'package:jsmu/core/widgets/app_loader.dart';
import 'package:jsmu/core/widgets/app_snackbar.dart';

import '../models/partner_dashboard_model.dart';
import '../providers/partner_provider.dart';

class PartnerDashboardScreen extends StatefulWidget {
  const PartnerDashboardScreen({super.key});

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PartnerProvider>().fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final partner = context.watch<PartnerProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: partner.isLoading && partner.dashboard == null
            ? const Center(
                child: AppLoader(message: 'Loading Partner Pro Radar...'),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.p8),
                    // 1. Partner Top Profile & Duty Bar
                    _buildTopDutyBar(context, partner),

                    const SizedBox(height: AppSizes.p14),

                    // 2. Auto-Dispatch Toggle Card
                    _buildAutoDispatchCard(partner),

                    const SizedBox(height: AppSizes.p14),

                    // 3. Flash Surge Bonus Challenge Banner
                    _buildFlashSurgeBanner(),

                    const SizedBox(height: AppSizes.p16),

                    // 4. 2x2 Performance Metrics Grid
                    _buildMetricsGrid(partner.dashboard!),

                    const SizedBox(height: AppSizes.p16),

                    // 5. Active Next Job Card with Navigation CTA
                    _buildNextJobCard(context),

                    const SizedBox(height: AppSizes.p16),

                    // 6. Surge & Demand Zones Live Radar Map
                    _buildSurgeZonesCard(),

                    const SizedBox(height: AppSizes.p20),

                    // 7. Today's Full Chronological Schedule
                    _buildTodaySchedule(partner.dashboard!),

                    const SizedBox(height: AppSizes.p20),

                    // 8. Partner Toolkit
                    _buildPartnerToolkit(context),

                    const SizedBox(height: AppSizes.p24),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNav(context, partner),
    );
  }

  Widget _buildTopDutyBar(BuildContext context, PartnerProvider partner) {
    final dash = partner.dashboard!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            partner.setActivePartnerNav(3);
            Navigator.pushNamed(context, '/partner-profile');
          },
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
                  fit: BoxFit.cover,
                  placeholder: (c, u) =>
                      Container(color: AppColors.surfaceCard),
                  errorWidget: (c, u, e) => const Icon(Icons.person),
                ),
              ),
              const SizedBox(width: AppSizes.p10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${dash.partnerName} ${dash.partnerId}',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: partner.isOnline
                              ? AppColors.onlineGreen
                              : AppColors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        partner.isOnline
                            ? 'Online • On Duty'
                            : 'Offline • Off Duty',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: partner.isOnline
                              ? AppColors.onlineGreen
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/partner-earnings'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p10,
                  vertical: AppSizes.p6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      Formatters.formatCurrency(dash.walletBalance),
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSizes.p6),
            IconButton(
              onPressed: () =>
                  AppSnackbar.showInfo(context, 'No emergency alerts'),
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textPrimary,
                size: 22,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAutoDispatchCard(PartnerProvider partner) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p14,
        vertical: AppSizes.p10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.p8),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Icon(
                  Icons.navigation_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSizes.p10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-Dispatch Active',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Sector 48-49 Corridor • High GPS',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: partner.isOnline,
            activeThumbColor: AppColors.primary,
            onChanged: (val) {
              partner.toggleOnlineStatus();
              AppSnackbar.showInfo(
                context,
                val ? 'Online and accepting requests' : 'Went offline',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSurgeBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p14,
        vertical: AppSizes.p10,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.p6),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: AppSizes.p10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flash Surge Bonus!',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Complete 2 more jobs today to unlock bonus',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p8,
              vertical: AppSizes.p4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            ),
            child: Text(
              '1/3 Done',
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 10,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(PartnerDashboardModel dash) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: "TODAY'S EARNINGS",
                value: Formatters.formatCurrency(dash.todayEarnings),
                subtitle:
                    'Target: ${Formatters.formatCurrency(dash.targetEarnings)}',
                badgeText: '71% Reached',
                showProgress: true,
                progressVal: 0.71,
              ),
            ),
            const SizedBox(width: AppSizes.p10),
            Expanded(
              child: _buildMetricCard(
                title: 'JOBS VELOCITY',
                value: '${dash.jobsCompletedToday}/${dash.totalJobsScheduled}',
                subtitle: '${dash.pendingSlots} Slots Pending',
                badgeText: 'On Track for 18:30',
                icon: Icons.speed_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p10),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'ACCEPTANCE',
                value: '${dash.acceptanceRate}%',
                subtitle: dash.partnerTier,
                badgeText: 'Top 5% Hub',
                icon: Icons.shield_outlined,
              ),
            ),
            const SizedBox(width: AppSizes.p10),
            Expanded(
              child: _buildMetricCard(
                title: 'RATING & TRUST',
                value: '${dash.rating} ★',
                subtitle: '${dash.reviewCount} reviews',
                badgeText: 'Zero Complaints',
                icon: Icons.star_outline_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required String badgeText,
    IconData? icon,
    bool showProgress = false,
    double progressVal = 0.0,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 9,
                  color: AppColors.textMuted,
                ),
              ),
              if (icon != null) Icon(icon, size: 14, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          if (showProgress) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              child: LinearProgressIndicator(
                value: progressVal,
                minHeight: 4,
                backgroundColor: AppColors.borderLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppSizes.radiusXs),
            ),
            child: Text(
              badgeText,
              style: AppTextStyles.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextJobCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
                child: Text(
                  'Next Job in 35 mins',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                '3.2 km away',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Power Jet AC Servicing',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '₹480 + Tips',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '2 Split Units • Deep chemical wash & drain sanitization',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primarySoft,
                child: Text(
                  'PS',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priya Sharma',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Flat 402, Lotus Greens, Indiranagar',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () =>
                    AppSnackbar.showInfo(context, 'Calling customer...'),
                icon: const Icon(
                  Icons.call_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/partner-job-execution'),
                  icon: const Icon(
                    Icons.play_circle_filled_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text('Navigate & Start Job Execution'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: IconButton(
                  onPressed: () => AppSnackbar.showInfo(context, 'Chat opened'),
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSurgeZonesCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.p12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.radar_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Surge & Demand Zones',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                  ),
                  child: Text(
                    'Live Radar',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.success,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 120,
            width: double.infinity,
            color: const Color(0xFFE4ECEF),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=600&q=80',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (c, u) =>
                      Container(color: AppColors.surfaceCard),
                  errorWidget: (c, u, e) =>
                      Container(color: AppColors.surfaceMuted),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Text(
                      'Sector 54 • 1.4x Surge Active',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Text(
                      'Sector 48 • High AC Demand',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.p10),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 12,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'AC servicing requests are up 42% this afternoon due to 39°C temperature spike.',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule(PartnerDashboardModel dash) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Schedule",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Saturday, 27 May',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p12),
        ...dash.schedule.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSizes.p10),
            padding: const EdgeInsets.all(AppSizes.p12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: item.isNext ? AppColors.primary : AppColors.borderLight,
                width: item.isNext ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.p6),
                      decoration: BoxDecoration(
                        color: item.isCompleted
                            ? AppColors.successLight
                            : (item.isNext
                                  ? AppColors.warningLight
                                  : AppColors.surfaceCard),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.isCompleted
                            ? Icons.check
                            : (item.isNext
                                  ? Icons.access_time_rounded
                                  : Icons.calendar_today_outlined),
                        size: 14,
                        color: item.isCompleted
                            ? AppColors.success
                            : (item.isNext
                                  ? AppColors.warning
                                  : AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: AppSizes.p10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.time} • ${item.status}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: item.isCompleted
                                ? AppColors.success
                                : (item.isNext
                                      ? AppColors.warning
                                      : AppColors.textSecondary),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          item.title,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          item.location,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  item.amount,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: item.isCompleted
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPartnerToolkit(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partner Toolkit',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSizes.p12),
        Row(
          children: [
            Expanded(
              child: _buildToolkitButton(
                icon: Icons.inventory_2_outlined,
                label: 'Spares Kit',
                onTap: () =>
                    AppSnackbar.showInfo(context, 'Spares Kit: In Stock'),
              ),
            ),
            const SizedBox(width: AppSizes.p10),
            Expanded(
              child: _buildToolkitButton(
                icon: Icons.receipt_long_outlined,
                label: 'Invoices',
                onTap: () => Navigator.pushNamed(context, '/partner-earnings'),
              ),
            ),
            const SizedBox(width: AppSizes.p10),
            Expanded(
              child: _buildToolkitButton(
                icon: Icons.emergency_outlined,
                label: 'Emergency',
                color: AppColors.error,
                onTap: () =>
                    AppSnackbar.showWarning(context, 'Emergency SOS Activated'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolkitButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color ?? AppColors.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, PartnerProvider partner) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.p8,
        horizontal: AppSizes.p12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            0,
            Icons.radar_rounded,
            'Radar',
            partner.activePartnerNav == 0,
            () {
              partner.setActivePartnerNav(0);
            },
          ),
          _buildNavItem(
            1,
            Icons.calendar_month_outlined,
            'Jobs',
            partner.activePartnerNav == 1,
            () {
              partner.setActivePartnerNav(1);
              Navigator.pushNamed(context, '/partner-dispatch');
            },
          ),
          _buildNavItem(
            2,
            Icons.account_balance_wallet_outlined,
            'Earnings',
            partner.activePartnerNav == 2,
            () {
              partner.setActivePartnerNav(2);
              Navigator.pushNamed(context, '/partner-earnings');
            },
          ),
          _buildNavItem(
            3,
            Icons.person_outline_rounded,
            'Profile',
            partner.activePartnerNav == 3,
            () {
              partner.setActivePartnerNav(3);
              Navigator.pushNamed(context, '/partner-profile');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p14,
              vertical: AppSizes.p4,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primarySoft : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
