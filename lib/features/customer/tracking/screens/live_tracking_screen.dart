import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jsmu/core/constants/app_colors.dart';
import 'package:jsmu/core/constants/app_sizes.dart';
import 'package:jsmu/core/constants/app_strings.dart';
import 'package:jsmu/core/theme/app_text_styles.dart';
import 'package:jsmu/core/utils/formatters.dart';
import 'package:jsmu/core/widgets/app_button.dart';
import 'package:jsmu/core/widgets/app_loader.dart';
import 'package:jsmu/core/widgets/app_snackbar.dart';

import '../models/tracking_status_model.dart';
import '../providers/tracking_provider.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingProvider>().fetchTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trackingProv = context.watch<TrackingProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.livePartnerTracking,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => AppSnackbar.showInfo(
              context,
              'Customer Support: +91 800-456-7890',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.p16),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.surfaceCard),
                errorWidget: (c, u, e) => const Icon(Icons.person, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: trackingProv.isLoading && trackingProv.tracking == null
          ? const Center(
              child: AppLoader(message: 'Connecting to live partner GPS...'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.p8),
                  // 1. Status Header Card
                  _buildStatusHeaderCard(trackingProv.tracking!),

                  const SizedBox(height: AppSizes.p16),

                  // 2. Interactive Map Tracking View
                  _buildLiveMapCard(trackingProv.tracking!),

                  const SizedBox(height: AppSizes.p16),

                  // 3. Partner Profile Card
                  _buildPartnerProfileCard(context, trackingProv.tracking!),

                  const SizedBox(height: AppSizes.p16),

                  // 4. Start Service OTP Card
                  _buildOtpCard(context, trackingProv.tracking!),

                  const SizedBox(height: AppSizes.p16),

                  // 5. Service Summary & Price Breakdown Accordion
                  _buildServiceSummaryCard(trackingProv),

                  const SizedBox(height: AppSizes.p16),

                  // 6. Damage Protection Card
                  _buildDamageProtectionCard(),

                  const SizedBox(height: AppSizes.p14),

                  // 7. Helpful Tip Card
                  _buildHelpfulTipCard(),

                  const SizedBox(height: AppSizes.p20),

                  // 8. Primary CTA: Message Rajesh Directly
                  AppButton(
                    text:
                        'Message ${trackingProv.tracking?.partnerName ?? "Partner"} directly',
                    leadingIcon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () {
                      AppSnackbar.showInfo(
                        context,
                        'Opening secure in-app chat with Rajesh...',
                      );
                    },
                  ),

                  const SizedBox(height: AppSizes.p12),

                  // 9. Secondary Action Buttons (Reschedule / Help)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            AppSnackbar.showInfo(
                              context,
                              'Reschedule requested. Choose another slot.',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.surfaceCard,
                            side: const BorderSide(
                              color: AppColors.borderLight,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.p12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusPill,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: AppColors.textPrimary,
                              ),
                              const SizedBox(width: AppSizes.p6),
                              Text(
                                AppStrings.reschedule,
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.p12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            AppSnackbar.showInfo(
                              context,
                              'Help desk connected',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.surfaceCard,
                            side: const BorderSide(
                              color: AppColors.borderLight,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.p12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusPill,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.support_agent_rounded,
                                size: 16,
                                color: AppColors.textPrimary,
                              ),
                              const SizedBox(width: AppSizes.p6),
                              Text(
                                AppStrings.helpAndFaq,
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.p16),

                  // 10. Cancel Booking Link
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showCancelDialog(context);
                      },
                      child: Text(
                        AppStrings.cancelBooking,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.p28),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusHeaderCard(TrackingStatusModel data) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
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
              Text(
                'BOOKING #${data.bookingId}',
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p10,
                  vertical: AppSizes.p4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSizes.p6),
                    Text(
                      data.status,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data.etaMinutes} mins away',
                    style: AppTextStyles.displayMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Estimated arrival at ${data.estimatedTime}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppSizes.p10),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceCard,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delivery_dining_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p16),
          // Progress bar with stages
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                child: LinearProgressIndicator(
                  value: 0.45,
                  minHeight: 5,
                  backgroundColor: AppColors.borderLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assigned',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'En Route',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'In Progress',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    'Completed',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMapCard(TrackingStatusModel data) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5ECF0),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: AppColors.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Styled Map Background Image
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=800&q=80',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (c, u) => Container(color: AppColors.surfaceCard),
            errorWidget: (c, u, e) => Container(color: AppColors.surfaceMuted),
          ),
          Container(color: Colors.white.withValues(alpha: 0.25)),

          // Route Line (Custom Painted curve)
          CustomPaint(
            size: const Size(double.infinity, 220),
            painter: _RoutePathPainter(),
          ),

          // Live GPS Tracking Pill
          Positioned(
            top: AppSizes.p12,
            left: AppSizes.p12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p10,
                vertical: AppSizes.p4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.navigation_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Live GPS Tracking',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rajesh Pin Marker
          Positioned(
            top: 60,
            left: 70,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p8,
                    vertical: AppSizes.p3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    '${data.partnerName.split(' ').first} • ${data.partnerDistanceKm} km',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.handyman_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),

          // Home Destination Pin Marker
          Positioned(
            bottom: 40,
            right: 70,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p8,
                    vertical: AppSizes.p3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                  child: Text(
                    'Your Home',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),

          // Re-center Target Button
          Positioned(
            bottom: AppSizes.p12,
            right: AppSizes.p12,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.p8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.my_location_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerProfileCard(
    BuildContext context,
    TrackingStatusModel data,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 52,
                    height: 52,
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
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSizes.p12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.partnerName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      data.partnerRole,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.starGold,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${data.partnerRating}',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          ' • ${data.partnerJobs}',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => AppSnackbar.showInfo(
                      context,
                      'Calling Rajesh Kumar...',
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.p10),
                      decoration: const BoxDecoration(
                        color: AppColors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.call_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.p8),
                  GestureDetector(
                    onTap: () => AppSnackbar.showInfo(
                      context,
                      'Opening chat with Rajesh...',
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.p10),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat_bubble_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p12),
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: AppSizes.p8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p8,
                    vertical: AppSizes.p4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Background Verified',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.p8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p8,
                    vertical: AppSizes.p4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.medical_services_outlined,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Fully Vaccinated',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtpCard(BuildContext context, TrackingStatusModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p14,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.startServiceOtp,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Share with ${data.partnerName.split(' ').first} on arrival',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p14,
              vertical: AppSizes.p6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Text(
              data.otp.split('').join(' '),
              style: AppTextStyles.currencyBold.copyWith(
                color: Colors.white,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSummaryCard(TrackingProvider trackingProv) {
    final data = trackingProv.tracking!;
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
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
              Expanded(
                child: Text(
                  data.serviceTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                Formatters.formatCurrency(data.price),
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            data.serviceDesc,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSizes.p12),
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: AppSizes.p10),
          _buildInfoRow(Icons.calendar_month_outlined, data.timeSlot),
          const SizedBox(height: AppSizes.p8),
          _buildInfoRow(Icons.location_on_outlined, data.address),
          const SizedBox(height: AppSizes.p8),
          _buildInfoRow(
            Icons.account_balance_wallet_outlined,
            data.paymentInfo,
          ),
          const SizedBox(height: AppSizes.p12),
          GestureDetector(
            onTap: trackingProv.toggleBreakdown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View price breakdown',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  trackingProv.isBreakdownExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          if (trackingProv.isBreakdownExpanded) ...[
            const SizedBox(height: AppSizes.p10),
            Container(
              padding: const EdgeInsets.all(AppSizes.p10),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Column(
                children: [
                  _buildBreakdownItem('Base Service Fare', '₹599'),
                  _buildBreakdownItem('Service Tax & GST (18%)', 'Included'),
                  _buildBreakdownItem('Safety & Hygiene Fee', 'FREE'),
                  const Divider(color: AppColors.borderLight),
                  _buildBreakdownItem(
                    'Total Paid via UPI',
                    '₹599',
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(
    String label,
    String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppSizes.p8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDamageProtectionCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.p8),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSizes.p10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.damageProtection,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Every booking is backed by our full damage coverage and satisfaction guarantee.',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpfulTipCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.warning,
            size: 18,
          ),
          const SizedBox(width: AppSizes.p8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Helpful tip before arrival',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Please ensure the area beneath your indoor AC unit is cleared of electronics and delicate furniture for seamless power jet cleaning.',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        title: Text('Cancel Booking?', style: AppTextStyles.titleLarge),
        content: Text(
          'Are you sure you want to cancel this booking? Free cancellation is active.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Keep Booking',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              AppSnackbar.showInfo(context, 'Booking #HS-89421 canceled.');
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text(
              'Confirm Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(100, 95);
    path.cubicTo(120, 120, 180, 140, size.width - 100, size.height - 60);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
