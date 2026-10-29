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

import '../models/partner_wallet_model.dart';
import '../providers/partner_provider.dart';

class PartnerEarningsScreen extends StatefulWidget {
  const PartnerEarningsScreen({super.key});

  @override
  State<PartnerEarningsScreen> createState() => _PartnerEarningsScreenState();
}

class _PartnerEarningsScreenState extends State<PartnerEarningsScreen> {
  int _selectedSplitTab = 0; // 0: Today, 1: This Week, 2: Oct 2024

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PartnerProvider>().fetchWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final partner = context.watch<PartnerProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: partner.isLoading && partner.wallet == null
            ? const Center(
                child: AppLoader(message: 'Loading partner wallet...'),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.p8),
                    // 1. Top Duty Header Bar
                    _buildTopHeader(context, partner),

                    const SizedBox(height: AppSizes.p14),

                    // 2. Live Settlement Cycle Card
                    _buildLiveSettlementCard(partner.wallet!),

                    const SizedBox(height: AppSizes.p16),

                    // 3. Available Balance Card with Instant Cash Out
                    _buildAvailableBalanceCard(context, partner.wallet!),

                    const SizedBox(height: AppSizes.p16),

                    // 4. Weekly Quest Card (Super Pro Bonus)
                    _buildWeeklyQuestCard(partner.wallet!),

                    const SizedBox(height: AppSizes.p20),

                    // 5. Revenue Split Breakdown
                    _buildRevenueSplitSection(partner.wallet!),

                    const SizedBox(height: AppSizes.p20),

                    // 6. Recent Wallet Activity
                    _buildRecentActivitySection(context, partner.wallet!),

                    const SizedBox(height: AppSizes.p28),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNav(context, partner),
    );
  }

  Widget _buildTopHeader(BuildContext context, PartnerProvider partner) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.surfaceCard),
                errorWidget: (c, u, e) => const Icon(Icons.person),
              ),
            ),
            const SizedBox(width: AppSizes.p10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rajesh Kumar #HC-4029',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.onlineGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Online • OnDuty',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onlineGreen,
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
        Row(
          children: [
            Container(
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
                    Formatters.formatCurrency(
                      partner.dashboard?.walletBalance ?? 3450,
                    ),
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.p6),
            IconButton(
              onPressed: () {},
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

  Widget _buildLiveSettlementCard(PartnerWalletModel wallet) {
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
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.onlineGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Live Settlement Cycle',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
                child: Text(
                  'Auto-Sync Active',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Net Generated",
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Formatters.formatCurrency(wallet.grossTotal),
                    style: AppTextStyles.displayMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      color: AppColors.success,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+18.4% vs y\'day',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableBalanceCard(
    BuildContext context,
    PartnerWalletModel wallet,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Available Balance',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatCurrency(wallet.availableBalance),
                    style: AppTextStyles.currencyBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppSizes.p10),
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p14),
          // Linked Bank Row
          Container(
            padding: const EdgeInsets.all(AppSizes.p10),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.p6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.p10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallet.linkedBank,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Linked Primary UPI & IMPS',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                  ),
                  child: Text(
                    'Verified',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.p14),
          AppButton(
            text: AppStrings.instantCashOut,
            leadingIcon: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () {
              AppSnackbar.showSuccess(
                context,
                'Withdrawal initiated! ₹4,320 credited to HDFC bank.',
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 12,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                'Zero fee • Instant settlement in under 60 seconds',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyQuestCard(PartnerWalletModel wallet) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'WEEKLY QUEST',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    ' • ${wallet.questDaysLeft} days left',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.military_tech_outlined,
                      color: AppColors.primary,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      wallet.questTier,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            wallet.questTitle,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${wallet.completedJobs} of ${wallet.targetJobs} jobs finished',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
              ),
              Text(
                '${wallet.questPercent}% Completed',
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            child: LinearProgressIndicator(
              value: wallet.questPercent / 100.0,
              minHeight: 5,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.p12),
          // Direct Cash Reward Box
          Container(
            padding: const EdgeInsets.all(AppSizes.p10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.p6),
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.card_giftcard_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSizes.p10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹1,500 Direct Cash Reward',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Complete 7 more bookings before Sunday midnight.',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 5-Day Streak Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_outlined,
                    color: AppColors.warning,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '5-Day On-Time Streak',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '100% arrival reliability',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 9,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
                child: Text(
                  '+₹250 Protected',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueSplitSection(PartnerWalletModel wallet) {
    final tabs = ['Today', 'This Week', 'Oct 2024'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Revenue Split',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              children: List.generate(tabs.length, (idx) {
                final isSel = _selectedSplitTab == idx;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSplitTab = idx),
                  child: Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                      border: Border.all(
                        color: isSel ? AppColors.border : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      tabs[idx],
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 10,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p12),
        Container(
          padding: const EdgeInsets.all(AppSizes.p14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              _buildSplitRow(
                icon: Icons.handyman_outlined,
                title: 'Service Base Earnings',
                subtitle: '4 Completed Jobs',
                amount: Formatters.formatCurrency(wallet.serviceBase),
              ),
              const SizedBox(height: 10),
              _buildSplitRow(
                icon: Icons.verified_outlined,
                title: 'On-Site Add-On Commission',
                subtitle: 'Anti-rust coating sale',
                amount: Formatters.formatCurrency(wallet.addOnCommission),
              ),
              const SizedBox(height: 10),
              _buildSplitRow(
                icon: Icons.speed_rounded,
                title: 'Zone Surge & High Demand',
                subtitle: 'Indiranagar evening rush',
                amount: Formatters.formatCurrency(wallet.zoneSurge),
              ),
              const SizedBox(height: 10),
              _buildSplitRow(
                icon: Icons.volunteer_activism_outlined,
                title: 'Customer Tips',
                subtitle: '100% kept by partner',
                amount: Formatters.formatCurrency(wallet.tips),
                amountColor: AppColors.success,
              ),
              const SizedBox(height: 10),
              _buildSplitRow(
                icon: Icons.percent_rounded,
                title: 'Platform Fee (Promo Tier)',
                subtitle: '',
                amount: '₹0',
                amountColor: AppColors.success,
                strikethrough: '₹280',
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.borderLight),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gross Total Revenue',
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Zero commissions deducted today',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    Formatters.formatCurrency(wallet.grossTotal),
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSplitRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    Color? amountColor,
    String? strikethrough,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.p6),
          decoration: const BoxDecoration(
            color: AppColors.surfaceCard,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: AppColors.primary),
        ),
        const SizedBox(width: AppSizes.p10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            if (strikethrough != null) ...[
              Text(
                strikethrough,
                style: AppTextStyles.bodySmall.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              amount,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: amountColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection(
    BuildContext context,
    PartnerWalletModel wallet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Wallet Activity',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  AppSnackbar.showInfo(context, 'Full passbook downloaded'),
              child: Text(
                'View Passbook >',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p12),
        ...wallet.activities.map((act) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSizes.p10),
            padding: const EdgeInsets.all(AppSizes.p12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.p8),
                  decoration: BoxDecoration(
                    color: act.isPositive
                        ? AppColors.successLight
                        : AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    act.isPositive
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded,
                    color: act.isPositive
                        ? AppColors.success
                        : AppColors.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppSizes.p10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        act.title,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        act.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      act.amount,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: act.isPositive
                            ? AppColors.success
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      act.status,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        // Tax & TDS Statements Card
        Container(
          padding: const EdgeInsets.all(AppSizes.p12),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax & TDS Statements',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Download monthly GST & Form 16A summary',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => AppSnackbar.showSuccess(
                  context,
                  'Monthly GST & Form 16A PDF downloaded',
                ),
                icon: const Icon(Icons.download_rounded, size: 14),
                label: const Text('PDF'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ],
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
          _buildNavItem(0, Icons.radar_rounded, 'Radar', false, () {
            Navigator.pushReplacementNamed(context, '/partner-dashboard');
          }),
          _buildNavItem(1, Icons.calendar_month_outlined, 'Jobs', false, () {
            Navigator.pushReplacementNamed(context, '/partner-dispatch');
          }),
          _buildNavItem(
            2,
            Icons.account_balance_wallet_outlined,
            'Earnings',
            true,
            () {},
          ),
          _buildNavItem(3, Icons.person_outline_rounded, 'Profile', false, () {
            Navigator.pushReplacementNamed(context, '/partner-profile');
          }),
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
