import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jsmu/core/constants/app_colors.dart';
import 'package:jsmu/core/constants/app_sizes.dart';
import 'package:jsmu/core/services/location_service.dart';
import 'package:jsmu/core/theme/app_text_styles.dart';
import 'package:jsmu/core/widgets/app_snackbar.dart';
import 'package:jsmu/features/auth/providers/auth_provider.dart';
import '../providers/partner_provider.dart';

class PartnerProfileScreen extends StatefulWidget {
  const PartnerProfileScreen({super.key});

  @override
  State<PartnerProfileScreen> createState() => _PartnerProfileScreenState();
}

class _PartnerProfileScreenState extends State<PartnerProfileScreen> {
  bool _isDetectingLocation = false;
  String _partnerLocation = 'Sector 54 • Golf Course Road, Gurgaon';
  String _locationDetail = 'Auto-detecting live GPS position...';
  bool _isGpsVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detectPartnerLocation(askPermission: true);
      context.read<PartnerProvider>().fetchDashboard();
    });
  }

  Future<void> _detectPartnerLocation({bool askPermission = true}) async {
    if (!mounted) return;
    setState(() => _isDetectingLocation = true);

    try {
      final result = await LocationService.getCurrentLocation(
        askPermission: askPermission,
      );
      if (!mounted) return;

      setState(() {
        _isDetectingLocation = false;
        _partnerLocation = result.title;
        _locationDetail = result.subtitle;
        _isGpsVerified = !result.isDefault;
      });

      if (!result.isDefault && mounted) {
        AppSnackbar.showSuccess(
          context,
          'Partner GPS base updated: ${result.title}',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDetectingLocation = false;
        _locationDetail = 'Using default zone (GPS unavailable)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final partner = context.watch<PartnerProvider>();
    final auth = context.watch<AuthProvider>();
    final dash = partner.dashboard;

    final partnerName = dash?.partnerName ?? 'Rajesh Kumar';
    final partnerId = dash?.partnerId ?? '#PRO-9842';
    final rating = dash?.rating ?? 4.92;
    final reviewCount = dash?.reviewCount ?? '1,240+';
    final tier = dash?.partnerTier ?? 'Tier 1 Gold Partner';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/partner-dashboard');
            }
          },
        ),
        title: Text(
          'Partner Pro Account',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSizes.p16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: partner.isOnline
                        ? AppColors.onlineGreen
                        : AppColors.textMuted,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSizes.p4),
                Text(
                  partner.isOnline ? 'On Duty' : 'Off Duty',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: partner.isOnline
                        ? AppColors.onlineGreen
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.p16),

            // Partner Pro Identity Card
            Container(
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.starGold,
                                width: 2.5,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
                              fit: BoxFit.cover,
                              placeholder: (c, u) =>
                                  Container(color: AppColors.surfaceCard),
                              errorWidget: (c, u, e) => const Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 36,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_rounded,
                                color: AppColors.starGold,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: AppSizes.p14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    partnerName,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSizes.p6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.starGold.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusXs,
                                    ),
                                  ),
                                  child: Text(
                                    'PRO PARTNER',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: const Color(0xFF9E6500),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$partnerId • $tier',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.starGold,
                                  size: 16,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '$rating ($reviewCount reviews)',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p14),
                  const Divider(height: 1, color: AppColors.borderLight),
                  const SizedBox(height: AppSizes.p12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniStat(
                        'Jobs Done',
                        '${dash?.jobsCompletedToday ?? 3} today',
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: AppColors.borderLight,
                      ),
                      _buildMiniStat(
                        'Acceptance',
                        '${dash?.acceptanceRate ?? 98.4}%',
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: AppColors.borderLight,
                      ),
                      _buildMiniStat(
                        'Wallet',
                        '₹${dash?.walletBalance ?? 3450}',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.p16),

            // LIVE AUTO-DETECTED OPERATING LOCATION CARD
            Container(
              padding: const EdgeInsets.all(AppSizes.p14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: _isGpsVerified
                      ? AppColors.onlineGreen.withValues(alpha: 0.4)
                      : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.p10),
                    decoration: BoxDecoration(
                      color: _isGpsVerified
                          ? AppColors.onlineGreen.withValues(alpha: 0.12)
                          : AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isGpsVerified
                          ? Icons.my_location_rounded
                          : Icons.location_on_rounded,
                      color: _isGpsVerified
                          ? AppColors.onlineGreen
                          : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Auto-Detected Work Zone',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: AppSizes.p6),
                            if (_isGpsVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.onlineGreen.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusXs,
                                  ),
                                ),
                                child: Text(
                                  'GPS LIVE',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.onlineGreen,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _partnerLocation,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _locationDetail,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isDetectingLocation
                        ? null
                        : () => _detectPartnerLocation(askPermission: true),
                    icon: _isDetectingLocation
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : const Icon(
                            Icons.refresh_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                    tooltip: 'Detect real GPS location',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.p20),

            // VERIFICATION & DOCUMENTS SECTION
            Text(
              'Trust & Verification Status',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.p10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _buildDocRow(
                    icon: Icons.badge_outlined,
                    title: 'Government Identity (Aadhaar)',
                    subtitle: 'Verified • •••• 9921',
                    isVerified: true,
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  _buildDocRow(
                    icon: Icons.security_rounded,
                    title: 'Police Background Verification',
                    subtitle: 'Approved & Clear (Valid till Nov 2027)',
                    isVerified: true,
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  _buildDocRow(
                    icon: Icons.handyman_outlined,
                    title: 'Master AC & Electrician Certification',
                    subtitle: 'Skill India Level 4 Certified',
                    isVerified: true,
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  _buildDocRow(
                    icon: Icons.account_balance_rounded,
                    title: 'Payout Bank Account',
                    subtitle: 'HDFC Bank (•••• 8821) Active',
                    isVerified: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.p20),

            // QUICK ACTIONS & MODE SWITCH
            Text(
              'Partner Controls',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.p10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _buildActionRow(
                    icon: Icons.toggle_on_outlined,
                    title: 'Duty Status',
                    subtitle: partner.isOnline
                        ? 'Currently receiving job requests'
                        : 'Currently off duty',
                    trailing: Switch.adaptive(
                      value: partner.isOnline,
                      activeColor: AppColors.onlineGreen,
                      onChanged: (val) => partner.toggleOnlineStatus(),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  _buildActionRow(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Instant Payout Wallet',
                    subtitle:
                        '₹${dash?.walletBalance ?? 3450} available for payout',
                    onTap: () {
                      partner.setActivePartnerNav(2);
                      Navigator.pushNamed(context, '/partner-earnings');
                    },
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  _buildActionRow(
                    icon: Icons.logout_rounded,
                    title: 'Sign Out',
                    subtitle: 'Safely log out from this device',
                    textColor: AppColors.error,
                    onTap: () {
                      try {
                        auth.signOut();
                      } catch (_) {}
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamedAndRemoveUntil('/', (r) => false);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.p24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, partner),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildDocRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isVerified,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p14,
        vertical: AppSizes.p12,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: AppSizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.onlineGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.onlineGreen,
                    size: 12,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'VERIFIED',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onlineGreen,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p14,
          vertical: AppSizes.p12,
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? AppColors.textSecondary, size: 20),
            const SizedBox(width: AppSizes.p12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: textColor ?? AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textMuted,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, PartnerProvider partner) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.borderLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.radar_rounded, 'Radar', false, () {
            partner.setActivePartnerNav(0);
            Navigator.pushReplacementNamed(context, '/partner-dashboard');
          }),
          _buildNavItem(1, Icons.calendar_month_outlined, 'Jobs', false, () {
            partner.setActivePartnerNav(1);
            Navigator.pushReplacementNamed(context, '/partner-dispatch');
          }),
          _buildNavItem(
            2,
            Icons.account_balance_wallet_outlined,
            'Earnings',
            false,
            () {
              partner.setActivePartnerNav(2);
              Navigator.pushReplacementNamed(context, '/partner-earnings');
            },
          ),
          _buildNavItem(3, Icons.person_rounded, 'Profile', true, () {}),
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
          Icon(
            icon,
            size: 22,
            color: isActive ? AppColors.primary : AppColors.textMuted,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isActive ? AppColors.primary : AppColors.textMuted,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
